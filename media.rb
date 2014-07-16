class Media
    attr_accessor :name, :memes, :likes, :views

    def initialize(name, memes=[], likes=0)
        @name = name
        @memes = memes
        @likes = likes
    end
end
