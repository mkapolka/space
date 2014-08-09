class World
    attr_accessor :locations, :time, :player
    # Debugging information
    attr_accessor :dbg_people, :dbg_places

    def self.instance
        return @@instance ||= World.new
    end

    def find_person(id)
        return self.dbg_people[id.to_s]
    end

    def find_place(id)
        return self.dbg_places[id.to_s]
    end

    def initialize
        @locations = []
        @time = 0

        self.dbg_people = {}
        self.dbg_places = {}
    end

    def tick
        self.time += 1
        @locations.each &:tick
    end
end
