require_relative 'memes.rb'
require_relative 'media.rb'
require_relative 'world.rb'

class Location
    attr_accessor :name, :occupants

    def initialize
        @name = "No name"
        @occupants = []
        @memory = 3
    end

    def add_person(person)
        @occupants << person if not @occupants.include? person
    end

    def remove_person(person)
        @occupants.delete person
    end

    def tick
        self.occupants.each &:tick
    end

    def to_meme
        return @_meme ||= LocationMeme.new(self)
    end
end

class MediaBoard < Location
    attr_accessor :media, :max_media_age

    def initialize
        super
        @media = []
        @max_media_age = 3
    end

    def post_media(media, poster)
        raise Exception.new "Tried to post nil media" if media.nil?
        raise Exception.new "nil tried to post" if poster.nil?

        post = Post.new(media, poster, self)
        @media << post
        
        # reponses
        for person in self.occupants
            person.view_post(post)
        end
    end

    def media_posted?(media)
        posted_media = self.media.map(&:media)
        return posted_media.include? media
    end

    def tick
        super
        for post in self.media
            post.age += 1
            if post.age >= self.max_media_age
                self.media.delete(post)
            end
        end
    end
end

class Post < Media
    attr_accessor :site, :poster, :media, :comments, :age

    def initialize(media, poster, site)
        super ""
        @media = media
        @poster = poster
        @site = site
        @comments = []
        @age = 0
    end

    def memes
        return media.memes + [poster.to_meme, site.to_meme]
    end

    def name
        return "#{@media.name}, shared by #{@poster.name}"
    end

    def comment(who, comment)
        @comments << "#{who.name}: #{comment}"
        if poster.is_a? Player
            puts "#{who.name} tells you, \"#{comment}\""
        end
    end
end
