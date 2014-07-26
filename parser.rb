class Parser
    attr_accessor :player, :world

    def initialize(world, player)
        @player = player
        @world = world
    end

    def start(location)
        display_location(location)
        @player = player
    end

    def print_media_info(media)
        puts "* #{media.name}. #{media.likes} likes."
        puts "\tMemes: #{media.memes.map(&:name).join(", ")}"
    end

    def display_travel(world)
        finished = false
        while not finished
            puts "Where would you like to go?"
            for location in world.locations
                puts "[#{world.locations.index(location)}] #{location.name}"
            end

            puts "[b]ack"
            choice = gets.chomp
            if choice == 'b'
                finished = true
            elsif choice.to_i < world.locations.length
                location = world.locations[choice.to_i]
                puts "You hyper jump to #{location.name}"
                puts ""
                display_location(location)
            end
        end
    end

    def display_location(location)
        finished = false
        while not finished
            puts "You are at #{location.name}."
            puts "Shared media:"
            for media in location.media
                puts "\t#{media.name}"
            end

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

            action = gets.chomp
            puts ""

            if action == '1'
                display_travel(@world)
            elsif action == '2'
                display_posts_at_location(location)
            elsif action == '3'
                display_post_prompt(location)
            elsif action[0] == 'q'
                finished = true
            end
        end
    end

    def display_posts_at_location(location)
        finished = false
        while not finished
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
                end
                puts ""
            end

            puts ""
            puts "[b] Back to location"
            input = gets.chomp
            if input == 'b'
                display_location(location)
            elsif input.to_i < actions.length
                actions[input.to_i].call
                finished = true
                puts ""
            end
        end
    end

    def display_post_prompt(location)
        finished = false
        while not finished
            actions = []
            puts "Your media:"
            for media in @player.media
                print_media_info(media)
                puts "[#{actions.length + 1}] Share this?"
                actions << Proc.new do
                    puts "You rez a copy of #{media.name} and share it in #{location.name}"
                    location.post_media(media, player)
                end
            end

            puts ""
            puts "[b] Back"
            input = gets.chomp
            if input == 'b'
                finished = true
            elsif input.to_i < actions.length + 1
                actions[input.to_i - 1].call
                finished = true
                puts ""
            end
        end
    end
end
