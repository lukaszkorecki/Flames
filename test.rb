require './lib/Flames'

puts "DEBug MODE".red unless ENV['DEBUG'].nil?
Thread.abort_on_exception = true unless ENV['DEBUG'].nil?

ui = Flames::Ui.new
campfire = Flames::Campfire.new

rms = campfire.rooms

num = ui.menu rms
room = campfire.select_room rms[num]

app = Flames::App.new

app.post_proc = lambda {|str| room.post str }

# set up callbacks

room.on_listen << lambda { |message| app.buffer << message }
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

app.start
Thread.new { app.buffer << room.latest_messages }.join
