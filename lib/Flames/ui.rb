module Flames
  class Ui

    def self.menu rooms
      rooms.each_with_index do |name, idx|
        puts "#{idx} - #{name}"
      end
      ask("Pick a room", Integer)
    end

    def self.prompt message, room
      @p = Thread.new { room.speak ask("+-~> ") }
    end

    def self.render message
      Thread.new do
        puts format_type message
      end.join
    end

    def self.time
      [:hour, :min, :sec].map { |m| Time.now.send m }.join ':'
    end

    def self.format_type m
      out = case m['type']
      when 'TimestampMessage'
        "< #{time.green} >"
      when 'TextMessage'
        "<#{m['user']['name'].yellow}> #{m['body']}"
      when 'PasteMessage'
        s = "<#{m['user']['name'].yellow}"
        s << "\n"
        s << m['body']
        s
      when 'KickMessage'
        s = "< "
        s << "#{m['user']['name']} left the room".dark_green
        s << " >"
        s
      when 'EnterMessage'
        s = "< "
        s << "#{m['user']['name']} joined the room".dark_green
        s << " >"
        s
      else
        "Unknonw type! \n#{m.to_yaml}"
      end

      "\n#{out}"
    end
  end
end
