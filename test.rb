require './lib/Flames'

Thread.abort_on_exception = true unless ENV['DEBUG'].nil?

ui = Flames::Ui.new
campfire = Flames::Campfire.new

rms = campfire.rooms

num = ui.menu rms
room = campfire.select_room rms[num]


# set up callbacks
prompt = lambda { |message, room| ui.prompt message, room }
room.on_join << prompt
room.after_listen << prompt

room.on_listen << lambda { |message| ui.render message }
room.on_listen << lambda do |message|
  Notify.notify("Flames: #{message['user']['name']}", message['body']) unless message['body'].nil?
end

# join the room
room.join do
  puts  "Now chatting in #{rms[num].red}"
  Notify.notify( "Flames", "Now chatting in #{rms[num]}")
end

# get latest messages
puts "Recent messages".green
room.latest_messages.each do |msg|
  ui.render msg
end
puts "."*80
# display current messages
room.display

# don't exit!
loop {}
