class Person
    attr_accessor :name, :media, :location, :seen, :members, :world, :memory
    attr_accessor :known_locations
    # Memes
    attr_accessor :liked_memes, :disliked_memes

    def initialize(name, world)
        @name = name
        @liked_memes = []
        @disliked_memes = []
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
            common_memes = post.memes & self.liked_memes
            post.likes += common_memes.length * @members
            @seen << post.media
            
            # Comment on the post
            if self.likes_media? post
                post.comment(self, "I like this!")
            elsif self.dislikes_media? post
                post.comment(self, "This sucks!")
            else
                post.comment(self, "This is pretty meh.")
            end
            # TODO something about reposts?
        else
            # Seen it!
            response = [
                "Seen it!",
                "Ooooooold!"
            ].sample
            post.comment(self, response)
        end

    end

    def location=(where)
        @location.remove_person(self) if not @location.nil?
        where.add_person self
        @location = where
    end

    def store_media(media)
        @media << media if not @media.include? media
    end

    def dislikes_media?(media)
        likes = media.memes & self.liked_memes
        dislikes = media.memes & self.disliked_memes
        return dislikes.length > likes.length
    end

    def likes_media?(media)
        likes = media.memes & self.liked_memes
        dislikes = media.memes & self.disliked_memes
        return likes.length > dislikes.length
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
    
    def tick
        self.locations.each do |location|
            location.post_media(self.media.sample, self) if not self.media.empty?
        end
    end

    def _add_location(location)
        self.locations << location if not self.locations.include? location
    end

    def _remove_location(location)
        self.locations.delete location
    end
end
