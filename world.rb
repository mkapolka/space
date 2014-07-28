class World
    attr_accessor :locations, :time

    def initialize
        @locations = []
        @time = 0
    end

    def tick
        self.time += 1
        @locations.each &:tick
    end
end
