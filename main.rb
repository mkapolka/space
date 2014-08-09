require_relative 'space.rb'
require_relative 'memes.rb'
require_relative 'people.rb'
require_relative 'locations.rb'
require_relative 'parser.rb'
require_relative 'world.rb'
require_relative 'world_data.rb'

world = load_world($world_data)

player = world.player
parser = Parser.new(world, player)
parser.start(reddit)
