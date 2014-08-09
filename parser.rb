class Parser
    attr_accessor :player, :world, :finished

    def initialize(world, player)
        @player = player
        @world = world
    end

    def start
        @player = player
        @finished = false
        _loop
    end

    def _loop
        while not @finished
            display_location(@player.location)
        end
    end

    def print_media_info(media)
        puts "* #{media.name}. #{media.likes} likes."
        puts "\tMemes: #{media.memes.map(&:name).join(", ")}"
    end

    def print_person_info(person)
        aesthetic_string = "nothing"
        if person.liked_memes.length > 0
            aesthetic_string = person.liked_memes.map{|x| "[#{x.name}]"}.join(", ")
        end

        dislikes_string = "nothing"
        if person.disliked_memes.length > 0
            dislikes_string = person.disliked_memes.map{|x| "[#{x.name}]"}.join(", ")
        end

        if person.members == 1
            puts "#{person.name} likes #{aesthetic_string}, dislikes #{dislikes_string}"
        else
            puts "#{person.name} like #{aesthetic_string}, dislike #{dislikes_string}"
        end
    end

    def display_travel(world)
        success = false
        while not success
            puts "Where would you like to go?"
            potential_locations = player.known_locations
            for location in potential_locations
                puts "[#{potential_locations.index(location) + 1}] #{location.name}"
            end

            puts "[b]ack"
            choice = gets.chomp
            if choice == 'b'
                success = true
            elsif choice.to_i <= potential_locations.length
                location = potential_locations[choice.to_i - 1]
                puts "You hyper jump to #{location.name}"
                puts ""
                @player.location = location
                @world.tick
                success = true
            else
                puts "Invalid choice."
            end
        end
    end

    def display_location(location)
        puts "You are at #{location.name}."
        # Things to do :
        #   * Go somewhere else
        #   * See what's posted here
        #   * Post something here
        #   * See who's here?
        puts "What would you like to do?"
        puts " [1] Go somewhere else"
        puts " [2] View media"
        puts " [3] Share something"
        puts " [4] Examine members"
        puts " [5] Do nothing"

        action = gets.chomp
        puts ""

        if action == '1'
            display_travel(@world)
        elsif action == '2'
            display_posts_at_location(location)
        elsif action == '3'
            display_post_prompt(location)
        elsif action == '4'
            display_people_at_location(location)
        elsif action == '5'
            @world.tick
        elsif action == 'irb'
            require 'pry'
            binding.pry
        elsif action[0] == 'q'
            @finished = true
        else
            puts "Invalid action"
        end
    end

    def display_people_at_location(location)
        for person in location.occupants
            print_person_info(person) if not person == @player
        end
        puts ""
    end

    def display_posts_at_location(location)
        success = false
        while not success
            actions = []
            puts "Shared media:"
            for post in location.media
                print_media_info(post)
                puts "\tComments:"
                puts post.comments.map{|x| "\t\t#{x}"}.join("\n")
                puts "\t[#{actions.length}] Duplicate"
                actions << Proc.new do 
                    @player.store_media(post.media)
                    puts "You take a copy of #{post.media.name}"
                    @world.tick
                end
                puts ""
            end

            puts ""
            puts "[b] Back to location"
            input = gets.chomp
            if input == 'b'
                success = true
            elsif input.to_i < actions.length
                actions[input.to_i].call
                success = true
                puts ""
            else
                puts "Invalid action."
            end
        end
    end

    def display_post_prompt(location)
        success = false
        while not success
            actions = []
            puts "Your media:"
            for media in @player.media
                print_media_info(media)
                puts "[#{actions.length + 1}] Share this?"
                actions << Proc.new do
                    puts "You rez a copy of #{media.name} and share it in #{location.name}"
                    location.post_media(media, player)
                    @world.tick
                end
            end

            puts ""
            puts "[b] Back"
            input = gets.chomp
            if input == 'b'
                success = true
            elsif input.to_i < actions.length + 1
                actions[input.to_i - 1].call
                success = true
                puts ""
            else
                puts "Invalid option."
            end
        end
    end
end
