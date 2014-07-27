require_relative 'memes.rb'
require_relative 'media.rb'

class Location
    attr_accessor :name, :occupants

    def initialize
        @name = "No name"
        @occupants = []
    end

    def add_person(person)
        @occupants << person if not @occupants.include? person
    end
end

class MediaBoard < Location
    attr_accessor :media

    def initialize
        super
        @media = []
    end

    def _add_post(media)
        @media << media
    end

    def post_media(media, poster)
        post = Post.new(media, poster, self)
        _add_post(post)
        
        # reponses
        for person in self.occupants
            person.view_post(post)
        end
    end
end

class Post < Media
    attr_accessor :site, :poster, :media, :comments

    def initialize(media, poster, site)
        super ""
        @media = media
        @poster = poster
        @site = site
        @comments = []
    end

    def memes
        return media.memes + [PersonMeme.new(poster), LocationMeme.new(site)]
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
