class Media
    attr_accessor :name, :memes, :likes

    def initialize(name, memes=[], likes=0)
        @name = name
        @memes = memes
        @likes = likes
    end
end

class Meme
    attr_accessor :name

    def initialize(name)
        @name = name
    end
end

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

    def add_post(media)
        @media << media
    end
end

class Post
    attr_accessor :site, :poster, :media

    def initialize(media)
        @media = media
    end

    def name
        return @media.name
    end
end

class Person
    attr_accessor :name, :media, :location
    # Memes
    attr_accessor :aesthetics

    def initialize(name)
        @name = name
        @aesthetics = []
        @media = []
    end

    def view(post)
        # Find common memes
        common_memes = @aesthetics & post.media.memes
        post.likes += common.memes.length
    end

    def location=(where)
        where.add_person self
        @location = where
    end
end

class Community < Person
    attr_accessor :members, :location

    def view(post)
        common_memes = @aesthetics & post.media.memes
        post.likes += common_memes.length * @members
    end

    def location=(where)
        where.add_person self
        @location = where
    end
end
