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
    attr_accessor :members

    def view(post)
        common_memes = @aesthetics & post.media.memes
        post.likes += common_memes.length * @members
    end

    def location=(where)
        where.add_person self
        @location = where
    end
end
