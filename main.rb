require_relative 'space.rb'
require_relative 'memes.rb'
require_relative 'people.rb'
require_relative 'locations.rb'
require_relative 'parser.rb'
require_relative 'world.rb'

# Boards

reddit = MediaBoard.new
reddit.name = "Reddit"

other_board = MediaBoard.new
other_board.name = "OtherBoard"

cat_archives = MediaBoard.new
cat_archives.name = "The Cat Video Archives"

# Memes

cat_meme = Meme.new "cats"
dog_meme = Meme.new "dogs"

# People
community = Community.new "Redditors"
community.location = reddit
other_community = Community.new "OtherBoardians"
other_community.location = other_board

community.aesthetics << cat_meme
other_community.aesthetics << dog_meme

player = Player.new "Marek"

cat_lady = Person.new "The crazy cat lady"
cat_lady.location = cat_archives
cat_lady.aesthetics << cat_meme

# Media
top_cat_videos = (0..10).map{|x| Media.new("best_cat_videos_#{x}.mp9", [cat_meme])}

media1 = Media.new("crazy_cat_video.mp4", [cat_meme])
media2 = Media.new("cats_being_funny.mp4", [cat_meme])

# Set up the things
other_board.post_media(media2, other_community)
reddit.post_media(media1, community)
for vid in top_cat_videos
    cat_archives.post_media(vid, cat_lady)
end

world = World.new
world.locations << reddit
world.locations << other_board
world.locations << cat_archives

player.location = reddit
parser = Parser.new(world, player)
parser.start(reddit)
