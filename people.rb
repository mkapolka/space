require_relative 'memes.rb'

class Person
    attr_accessor :name, :media, :location, :seen, :members, :world, :memory, :links
    attr_accessor :player_karma
    attr_accessor :is_creative
    attr_accessor :known_locations
    # Memes
    attr_accessor :liked_memes, :disliked_memes

    def initialize(name, world)
        @name = name
        @liked_memes = []
        @disliked_memes = []
        @media = []
        @seen = []
        @links = []
        self.is_creative = false
        @known_locations = []
        self.members = 1

        self.player_karma = 0
    end
    
    def tick
        # Move to a different location
        location_meme = self.liked_memes.select{|x| x.is_a? LocationMeme}.sample
        new_location = location_meme.location if not location_meme.nil?
        if not new_location.nil? and self.location != new_location
            self.location.tell "#{self.name} leaves for #{new_location.name}"
            new_location.tell "#{self.name} arrives from #{self.location.name}"
            self.location = new_location
        end

        if self.is_creative
            new_media = self.create_media
            self.location.post_media(new_media, self)
        end

        if self.media.length > 0
            potential_posts = self.media.select{|x| not self.location.media_posted? x}
            self.location.post_media(potential_posts.sample, self) if not potential_posts.empty?
        end
    end

    def share_media(media)
        self.location.post_media(media, self) if not self.location.media_posted? media
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
                
                # Comment on the post
                if self.likes_media? post
                    post.likes += @members
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

                    # Add karma
                    if post.poster.is_a? Player
                        self.increase_reputation(post.poster)
                    end

                    self.media << post.media if not self.media.include? post.media

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
            @seen << post.media
        else
            # Seen it!
            response = [
                "Seen it!",
                "Ooooooold!"
            ].sample
            post.comment(self, response)
        end
    end

    def increase_reputation(who)
        if who.is_a? Player
            self.player_karma += 1
            new_location = self.links[self.player_karma - 1]
            rep_name = ["Known", "Liked", "Trusted"][self.player_karma - 1]
            puts ""
            puts "==============="
            puts "Your reputation with #{self.name} is now \"#{rep_name}.\""
            if not new_location.nil? and not who.known_locations.include? new_location
                puts "#{self.name} shares one of their secret links with you. You can now go to #{new_location.name}"
                who.known_locations << new_location
            end
            puts "==============="
            puts ""
        end
    end

    def create_media
        meme = self.liked_memes.sample
        name = "#{meme.name}_" + [
            "best", "neat", "woah", "fails", "cool", "epic", "lol", "rofl", "lmao", "omg", "!!!"
        ].sample + "." + [
            "mp9", "hjpg", "fab"
        ].sample
        Media.new name, [meme]
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
        neutrals = media.memes - likes - dislikes
        return dislikes.length > likes.length && dislikes.length > neutrals.length
    end

    def likes_media?(media)
        likes = media.memes & self.liked_memes
        dislikes = media.memes & self.disliked_memes
        neutrals = media.memes - likes - dislikes
        return likes.length > dislikes.length && likes.length > neutrals.length
    end

    def to_meme
        return @_meme ||= PersonMeme.new(self)
    end
end

class Player < Person
    def view_post(post)
        puts "#{post.poster.name} posted #{post.media.name}"
        post_locations = post.memes.select{|x| x.is_a? LocationMeme}.map &:location
        self.known_locations |= post_locations
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

        if self.is_creative
            new_media = self.create_media
            self.locations.each{|l| l.post_media(new_media, self)}
        end
    end

    def _add_location(location)
        self.locations << location if not self.locations.include? location
    end

    def _remove_location(location)
        self.locations.delete location
    end
end
