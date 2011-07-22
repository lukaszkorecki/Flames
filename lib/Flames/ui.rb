module Flames
  class Ui

    def self.menu rooms
      rooms.each_with_index do |name, idx|
        puts "#{idx} - #{name}"
      end
      ask("Pick a room", Integer)
    end

    def self.prompt message, room
      Thread.new { room.speak ask("+-~>") }
    end
    def self.render message
      puts format_type message
    end

    def self.time
      [:hour, :min, :sec].map { |m| Time.now.send m }.join ':'
    end

    def self.format_type m
      case m['type']
      when 'TimestampMessage'
        puts "< #{time.green} >"
      when 'TextMessage'
        "<#{m['user']['name'].yellow}> #{m['body']}"
      when 'PasteMessage'
        s = "<#{m['user']['name'].yellow}"
        s << "\n"
        s << m['body']
        s
      else
        "Unknonw type! \n#{m.to_yaml}"
      end
    end
  end
end
