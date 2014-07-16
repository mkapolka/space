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

        # Things to do :
        #   * Go somewhere else
        #   * See what's posted here
        #   * Post something here
        #   * See who's here?
        puts "What would you like to do?"
        puts " [1] Go somewhere else"
        puts " [2] View posts"
        puts " [3] Post something"
        puts " [4] Examine members"

        action = gets.chomp
        puts ""

        if action == '2'
            display_posts_at_location(location)
        end
    end

    def display_posts_at_location(location)
        puts "Posts:"
        for media in location.media
            puts "#{media.name}. #{media.likes} likes."
            puts "\tMemes: #{media.memes.map{|x| x.name}.join(", ")}"
        end
    end
end
