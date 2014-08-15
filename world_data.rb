require_relative 'world.rb'
require_relative 'people.rb'
require_relative 'locations.rb'
require_relative 'memes.rb'

$world_data = {
    :people => [
        {
            :id => "redditors",
            :likes => ["cats", "science"],
            :dislikes => ["imgurians"],
            :creative => true,
            :members => 100,
            :links => ["reddit", "pantyselling", "gold_lounge"]
        },
        {
            :id => "imgurians",
            :likes => ["redditors", "cats"],
            :members => 70,
            :links => ["imgur"]
        },
        {
            :id => "spaceghettos",
            :name => "Space Ghettos",
            :likes => ["gore", "sex"],
            :dislikes => ["redditors"],
            :links => ["space_ghetto", "erowid"],
            :members => 20
        },
        {
            :id => "gold_redditors",
            :name => "Gold Redditors",
            :likes => ["cats", "science", "redditors", "gold"],
            :members => 13
        },
        {
            :id => "gold_attache",
            :name => "The Gold Reddit Attache",
            :likes => ["cats", "science", "redditors", "gold_lounge", "gold_redditors"],
            :members => 1,
        },
        {
            :id => "gold_artist",
            :name => "The Gold Reddit Court Jester",
            :likes => ["cats", "science", "gold"],
            :creative => true
        },
        {
            :id => "cat_lady",
            :creative => true,
            :name => "The Crazy Cat Lady",
            :likes => ["cats", "cat_archive"],
            :members => 1
        },
        {
            :id => "panty_sellers",
            :name => "Panty Sellers",
            :creative => true,
            :likes => ["underwear", "sex", "capitalism"],
            :members => 13
        },
        {
            :id => "panty_buyers",
            :name => "Panty Buyers",
            :likes => ["underwear", "sex", "capitalism"],
            :members => 35
        }
    ],
    :places => [
        {
            :id => "reddit",
            :occupants => ["redditors", "imgurians", "gold_attache"]
        },
        {
            :id => "gold_lounge",
            :name => "The Reddit Gold Lounge",
            :occupants => ["gold_redditors", "gold_artist"]
        },
        {
            :id => "imgur",
            :occupants => ["imgurians"]
        },
        {
            :id => "spaceghetto",
            :name => "Space Ghetto",
            :occupants => ["spaceghettos"]
        },
        {
            :id => "cat_archive",
            :name => "The Cat Video Archive",
            :occupants => ["cat_lady"]
        },
        {
            :id => "pantyselling",
            :name => "/r/pantyselling",
            :occupants => ["panty_sellers", "panty_buyers"]
        },
        {
            :id => "erowid",
            :name => "Erowid",
            :occupants => ["spaceghettos"]
        }
    ],
    :media => [
        {
            :id => "reddit_pleaser",
            :name => "red-nip",
            :memes => ["science", "cats"]
        },
        {
            :id => "reddit_pleaser_2",
            :name => "red-nip-2.ewd",
            :memes => ["science", "cats"]
        }
    ],
    :player => {
        :location => "reddit",
        :known_locations => ["reddit", "spaceghetto", "imgur", "cat_archive"],
        :media => ["reddit_pleaser", "reddit_pleaser_2"]
    }
}

def load_world(world_data)
    world = World.instance    
    memes = {}
    people = {}
    places = {}
    media = {}

    # Make the people
    for person in world_data[:people]
        if (person[:members] || 1) == 1
            p = Person.new((person[:name] || person[:id]), world)
        else
            p = Community.new((person[:name] || person[:id]), world)
            p.members = person[:members]
        end

        p.name = person[:name] || person[:id].clone
        p.name = p.name.capitalize
        p.is_creative = person[:creative]
        people[person[:id]] = p
    end

    # Make the locations
    for location in world_data[:places]
        l = MediaBoard.new
        l.name = location[:name] || location[:id].clone
        l.name = l.name.capitalize
        location[:occupants].each do |who|
            person = people[who]
            l.occupants << person
            if person.members == 1
                person.location = l
            else
                person.add_location l
            end
        end
        places[location[:id]] = l
        world.locations << l
    end

    # Build up people links
    for person in world_data[:people]
        p = people[person[:id]]
        p.links = person[:links].map{|x| places[x]} if not person[:links].nil?
    end

    # Build up the memes
    for person in world_data[:people]
        for meme in (person[:likes] || []) | (person[:dislikes] || [])
            if not memes.keys.include? meme
                if people.keys.include? meme
                    m = people[meme].to_meme
                elsif places.keys.include? meme
                    m = places[meme].to_meme
                else
                    m = Meme.new meme
                end
                memes[meme] = m
            end
        end
    end

    # Make the freestanding media
    for media_info in world_data[:media]
        m = Media.new media_info[:name], media_info[:memes].map{|x| memes[x]}
        media[media_info[:id]] = m
    end

    # Associate people memes
    for person in world_data[:people]
        p = people[person[:id]]
        person[:likes] ||= []
        person[:dislikes] ||= []
        p.liked_memes = person[:likes].map {|x| memes[x]}
        p.disliked_memes = person[:dislikes].map {|x| memes[x]}

        p.liked_memes << p.to_meme
        # By default, add self meme and location meme
        if p.instance_of? Person
            p.liked_memes << p.location.to_meme
        else
            p.liked_memes.concat p.locations.map(&:to_meme)
        end
    end

    # Make the player
    player = Player.new "Player", world
    player.known_locations = world_data[:player][:known_locations].map {|x| places[x]}
    player.location = places[world_data[:player][:location]]
    player.media = world_data[:player][:media].map{|x| media[x]}
    world.player = player

    # debug information
    world.dbg_people = people
    world.dbg_places = places

    return world
end
