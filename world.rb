class World
    attr_accessor :locations, :time, :player

    def self.instance
        return @@instance ||= World.new
    end

    def initialize
        @locations = []
        @time = 0
    end

    def tick
        self.time += 1
        @locations.each &:tick
    end
end

def test_trade_routes(world)
    creatives = []
    for location in world.locations
        creatives.concat location.occupants.select {|x| x.is_creative}
    end

    for creative in creatives

    end
end

def detect_volatile_media(media, location)
end

def dvm_recurse(media, poster, location, visited_locations=[])
    for person in location.occupants
        if person.likes_media? media and person.liked_memes
        end
    end
end
