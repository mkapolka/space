require_relative 'space.rb'
require_relative 'memes.rb'
require_relative 'people.rb'
require_relative 'locations.rb'
require_relative 'parser.rb'
require_relative 'world.rb'
require_relative 'world_data.rb'

world = load_world($world_data)

if false
    # Boards

    reddit = MediaBoard.new
    reddit.name = "Reddit"

    other_board = MediaBoard.new
    other_board.name = "OtherBoard"

    imgur = MediaBoard.new
    imgur.name = "Imgur"

    cat_archives = MediaBoard.new
    cat_archives.name = "The Cat Video Archives"

    secret_board = MediaBoard.new
    secret_board.name = "The Gold Lounge"

    contentious_board = MediaBoard.new
    contentious_board.name = "Space Ghetto"

    # Memes

    cat_meme = Meme.new "cats"
    dog_meme = Meme.new "dogs"
    sex_meme = Meme.new "sex"
    science_meme = Meme.new "science"
    gore_meme = Meme.new "gore"

    # People
    community = Community.new "Redditors", world
    community.location = reddit
    community.liked_memes.concat [cat_meme, sex_meme, science_meme]
    community.disliked_memes.concat [gore_meme]
    community.is_creative = true

    imgur_community = Community.new "Imgurians", world
    imgur_community.add_location reddit
    imgur_community.add_location imgur
    imgur_community.liked_memes.concat [cat_meme, sex_meme, dog_meme]
    imgur_community.disliked_memes.concat [gore_meme, science_meme]


    secret_community = Community.new "Gold Redditors", world
    secret_community.add_location secret_board
    secret_community.liked_memes.concat [cat_meme, science_meme]

    gold_attache = Person.new "The Reddit Gold Attache", world
    gold_attache.location = reddit
    gold_attache.liked_memes = secret_community.liked_memes

    other_community = Community.new "OtherBoardians", world
    other_community.add_location other_board
    other_community.add_location reddit
    other_community.liked_memes.concat [dog_meme, sex_meme]

    contentious_community = Community.new "Space Ghettos", world
    contentious_community.location = contentious_board
    contentious_community.liked_memes.concat [sex_meme, gore_meme]

    # Inter community relationships and rivalries
    # Redditors hate imgurians
    community.disliked_memes.concat [imgur_community.to_meme]
    imgur_community.liked_memes.concat [community.to_meme]
    imgur_community.disliked_memes.concat [secret_community.to_meme]
    contentious_community.disliked_memes.concat [reddit.to_meme, community.to_meme]
    gold_attache.liked_memes.concat [secret_community.to_meme]
    secret_community.liked_memes.concat [community.to_meme]

    # Make sure that communities like the locations that they're occupying
    for location in world.locations
        for person in location.occupants
            person.liked_memes << location.to_meme if not person.liked_memes.include? location.to_meme  
        end
    end


    cat_lady = Person.new "The crazy cat lady", world
    cat_lady.location = cat_archives
    cat_lady.liked_memes << cat_meme

    player = Player.new "Marek", world

    # Media
    top_cat_videos = (0..10).map{|x| Media.new("best_cat_videos_#{x}.mp9", [cat_meme])}

    science_videos = (0..10).map{|x| Media.new("cool_science_lectures_#{x}.hjpg", [science_meme])}
    secret_community.media.concat(science_videos)

    media1 = Media.new("crazy_cat_video.mp9", [cat_meme])
    media2 = Media.new("dogs_being_funny.mp9", [dog_meme])
    media3 = Media.new("zany_cats.vrv", [cat_meme])

    # Set up the things
    other_board.post_media(media2, other_community)
    reddit.post_media(media1, community)
    imgur.post_media(media3, imgur_community)
    for vid in top_cat_videos
        cat_archives.post_media(vid, cat_lady)
    end
end

player = world.player
parser = Parser.new(world, player)
parser.start(reddit)
