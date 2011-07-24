require './lib/Flames'

Thread.abort_on_exception= true
campfire = Flames::Campfire.new

rms = campfire.rooms

num = Flames::Ui.menu rms


room = campfire.select_room rms[num]

puts "NOW SPEAKING IN #{rms[num].red}"

# set up callbacks
prompt = lambda { |message, room| Flames::Ui.prompt message, room }
room.on_join = prompt
room.after_listen = prompt

room.on_listen = lambda { |message| Flames::Ui.render message }

# join the room
room.join

# get latest messages
room.latest_messages.each do |msg|
  Flames::Ui.render msg
end
# display current messages
room.display

# don't exit!
loop {}
