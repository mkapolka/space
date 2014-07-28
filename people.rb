class Person
    attr_accessor :name, :media, :location, :seen, :members, :world
    attr_accessor :known_locations
    # Memes
    attr_accessor :aesthetics

    def initialize(name, world)
        @name = name
        @aesthetics = []
        @media = []
        @seen = []
        @known_locations = []
        self.members = 1
    end
    
    def tick
        self.location.post_media(self.media.sample, self) if self.media.length != 0
    end

    def view_post(post)
        if not @seen.include? post.media
            common_memes = common_memes(post)
            post.likes += common_memes.length * @members
            @seen << post.media
        end

        # Comment on the post
        if self.likes_media? post
            post.comment(self, "I like this!")
        elsif self.dislikes_media? post
            post.comment(self, "This sucks!")
        else
            post.comment(self, "This is pretty meh.")
        end
        # TODO something about reposts?
    end

    def location=(where)
        @location.remove_person(self) if not @location.nil?
        where.add_person self
        @location = where
    end

    def store_media(media)
        @media << media if not @media.include? media
    end

    def common_memes(media)
        return @aesthetics & media.memes
    end

    def dislikes_media?(media)
        return common_memes(media).length < 0
    end

    def likes_media?(media)
        common_memes(media).length > 0
    end
end

class Player < Person
    def view_post(post)
        puts "#{post.poster.name} posted #{post.media.name}"
    end

    def tick
    end
end

class Community < Person
    attr_accessor :locations
    def initialize(name, world)
        super name, world
        self.members = 10
        self.locations = []
    end

    def location=(where)
        where.add_person self
        @location = where
    end

    def add_location(location)
        self._add_location(location)
        location.add_person(self)
    end

    def remove_location(location)
        self._remove_location(location)
        location.remove_person(self)
    end

    def _add_location(location)
        self.locations << location if not self.locaitons.include? location
    end

    def _remove_location(location)
        self.locations.delete location
    end
end
