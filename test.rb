require './lib/Flames'

campfire = Flames::Campfire.new

rms = campfire.rooms

num = Flames::Ui.menu rms


room = campfire.join_room rms[num]

puts "NOW SPEAKING IN #{rms[num].red}"

room.latest_messages.each do |msg|
  Flames::Ui.render msg
end

prompt = lambda { |message, room| Flames::Ui.prompt message, room }
room.on_display  = prompt
room.after_listen = prompt

room.on_listen = lambda { |message| Flames::Ui.render message }

room.display
loop {}
