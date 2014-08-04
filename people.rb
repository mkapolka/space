require_relative 'memes.rb'

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
        # self.location.post_media(self.media.sample, self) if self.media.length != 0
    end

    def share_media(media)
        self.location.post_media(media, self) if not self.location.media_posted? media
        
        # liked_people = self.liked_memes.select {|x| x.is_a? PersonMeme}
        # for meme in liked_people
            # meme.person.receive_media(media, self)
        # end
    end

    def receive_media(media, sharer)
        # Receive media directly from another person
        if not self.seen.include? media
            @seen << media
            if not dislikes_person?(sharer)
                share_media(media)
            end
        end
    end

    def dislikes_person?(who)
        return self.disliked_memes.include? who.to_meme
    end

    def view_post(post)
        if not @seen.include? post.media
            if not self.dislikes_person?(post.poster)
                common_memes = post.memes & self.liked_memes
                post.likes += common_memes.length * @members
                @seen << post.media
                
                # Comment on the post
                if self.likes_media? post
                    self.share_media(post.media)

                    # Change tastes
                    not_liked_media = post.memes - self.liked_memes
                    if not not_liked_media.empty?
                        new_meme = not_liked_media.sample

                        if self.disliked_memes.include? new_meme
                            self.disliked_memes.delete new_meme
                            post.comment(self, "This is great! Maybe #{new_meme.name} aren't so bad after all!")
                        else
                            self.liked_memes << new_meme
                            post.comment(self, "This is great! Now I like #{new_meme.name}")
                        end
                    else
                        post.comment(self, "I like this!")
                    end

                elsif self.dislikes_media? post
                    post.comment(self, "This sucks!")

                    # Change tastes
                    not_liked_media = self.disliked_memes - post.memes
                    if not not_liked_media.empty?
                        new_meme = not_liked_media.sample

                        if self.liked_memes.include? new_meme
                            self.liked_memes.delete new_meme
                            post.comment(self, "This sucks. #{new_meme.name} used to be cool.")
                        else
                            self.disliked_memes << new_meme
                            post.comment(self, "Fuck this. #{new_meme.name} sucks now.")
                        end
                    else
                        post.comment(self, "This sucks!")
                    end
                else
                    post.comment(self, "This is pretty meh.")
                end
            else
                # Dislikes poster
                post.comment(self, "GTFO #{post.poster.name}!")
            end
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

    def to_meme
        return @_meme ||= PersonMeme.new(self)
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

    def share_media(media)
        for location in self.locations
            location.post_media(media, self) if not location.media_posted? media
        end

        # liked_people = self.liked_memes.select {|x| x.is_a? PersonMeme}
        # for meme in liked_people
            # meme.person.receive_media(media, self)
        # end
    end
    
    def tick
        self.locations.each do |location|
            # location.post_media(self.media.sample, self) if not self.media.empty?
        end
    end

    def _add_location(location)
        self.locations << location if not self.locations.include? location
    end

    def _remove_location(location)
        self.locations.delete location
    end
end
