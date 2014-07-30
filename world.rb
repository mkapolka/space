class World
    attr_accessor :locations, :time

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
