module Flames
  class Ui

    def initialize
      @formatter = Formatter.new
    end

    def menu rooms
      rooms.each_with_index do |name, idx|
        puts "#{idx} - #{name}"
      end
      ask("Pick a room", Integer)
    end

    def prompt message, room
      @p = Thread.new { room.speak ask("+-~> ") }
    end

    def render message
      Thread.new do
        puts @formatter.format message
      end.join
    end

  end
end
