require_relative 'space.rb'
require_relative 'memes.rb'
require_relative 'people.rb'
require_relative 'locations.rb'
require_relative 'parser.rb'

reddit = MediaBoard.new
reddit.name = "Reddit"
community = Community.new "Redditors"
community.location = reddit

cat_meme = Meme.new "cats"
media1 = Media.new("crazy_cat_video.mp4", [cat_meme])
reddit.post_media(media1, community)

marek = Person.new "Marek"

parser = Parser.new
parser.start(reddit)
