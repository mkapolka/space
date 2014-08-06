require_relative 'world.rb'
require_relative 'people.rb'
require_relative 'locations.rb'
require_relative 'memes.rb'

$world_data = {
    :people => [
        {
            :id => "redditors",
            :likes => ["cats", "science"],
            # :creative => true,
            :members => 100
        },
        {
            :id => "otherboardians",
            :likes => ["redditors", "cats"],
            :members => 70
        },
        {
            :id => "spaceghettos",
            :likes => ["gore"],
            :dislikes => ["redditors"],
            :members => 20
        }
    ],
    :places => [
        {
            :id => "reddit",
            :occupants => ["redditors", "otherboardians"]
        },
        {
            :id => "other_board",
            :name => "OtherBoard",
            :occupants => ["otherboardians"]
        },
        {
            :id => "spaceghetto",
            :name => "Space Ghetto",
            :occupants => ["spaceghettos"]
        }
    ]
}

def load_world(world_data)
    world = World.instance    
    memes = {}
    people = {}
    places = {}

    # Make the people
    for person in world_data[:people]
        if person[:members] > 1
            p = Person.new((person[:name] || person[:id]), world)
        else
            p = Community.new
            p.members = person.members
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
        l.occupants = location[:occupants].map{|x| people[x]}
        places[location[:id]] = l
        world.locations << l
    end

    # Build up the memes
    for person in world_data[:people]
        for meme in (person[:likes] || []) | (person[:dislikes] || [])
            if not memes.keys.include? meme
                if people.keys.include? meme
                    m = PersonMeme.new(people[meme])
                elsif places.keys.include? meme
                    m = LocationMeme.new(places[meme])
                else
                    m = Meme.new meme
                end
                memes[meme] = m
            end
        end
    end

    # Associate people memes
    for person in world_data[:people]
        p = people[person[:id]]
        person[:likes] ||= []
        person[:dislikes] ||= []
        p.liked_memes = person[:likes].map {|x| memes[x]}
        p.disliked_memes = person[:dislikes].map {|x| memes[x]}
    end

    return world
end
