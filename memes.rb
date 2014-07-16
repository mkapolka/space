class Meme
    attr_accessor :name

    def initialize(name)
        @name = name
    end
end

class PersonMeme < Meme
    attr_accessor :person

    def initialize(person)
        @person = person
    end

    def name
        @person.name
    end
end

class LocationMeme < Meme
    attr_accessor :location

    def initialize(location)
        @location = location
    end

    def name
        return @location.name
    end
end
