class Person
    attr_accessor :name, :media, :location, :seen, :members
    attr_accessor :is_creative
    # Memes
    attr_accessor :aesthetics

    def initialize(name)
        @name = name
        @aesthetics = []
        @media = []
        @seen = []
        self.is_creative = false
        self.members = 1
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

    def create_media
        Media.new "#{self.name}'s amazing creation" [self.liked_memes.sample]
    end

    def location=(where)
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
    end
end

class Community < Person
    def initialize(name)
        super name
        self.members = 10
    end

    def location=(where)
        where.add_person self
        @location = where
    end
end
