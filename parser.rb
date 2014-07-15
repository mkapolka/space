class Parser
    def start(location)
        display_location(location)
    end

    def display_location(location)
        puts "You are at #{location.name}."
        puts "Shared media:"
        for media in location.media
            puts "\t#{media.name}"
        end
    end
end
