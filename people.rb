class Person
    attr_accessor :name, :media, :location, :seen
    # Memes
    attr_accessor :aesthetics

    def initialize(name)
        @name = name
        @aesthetics = []
        @media = []
        @seen = []
    end

    def view_post(post)
        # Find common memes
        common_memes = @aesthetics & post.media.memes
        post.likes += common_memes.length
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
    attr_accessor :members

    def initialize(name)
        super name
        @members = 10
    end

    def view_post(post)
        if not @seen.include? post.media
            common_memes = common_memes(post)
            post.likes += common_memes.length * @members
            @seen << post.media
        end
        # TODO something about reposts?
    end

    def location=(where)
        where.add_person self
        @location = where
    end
end
