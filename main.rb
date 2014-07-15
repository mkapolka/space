require_relative 'space.rb'
require_relative 'parser.rb'

reddit = MediaBoard.new
reddit.name = "Reddit"
community = Community.new "Redditors"
community.location = reddit

cat_meme = Meme.new "cats"
media1 = Media.new("crazy_cat_video.mp4", [cat_meme])
post1 = Post.new(media1)
reddit.add_post(post1)

marek = Person.new "Marek"

parser = Parser.new
parser.start(reddit)
