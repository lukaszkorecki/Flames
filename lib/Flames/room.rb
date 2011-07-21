module Flames
  class Room

    def initialize room
      @room = room
      @room.join
    end

    def display
      Thread.new do
        @room.listen do |m|
          puts 'listening'
          pr = <<-MESSAGE
<#{m[:person]}> #{m[:message]}
-------- #{Time.now}
        MESSAGE
        STDOUT << pr
        end
      end
    end

    def post str
      @room.speak str
    end

    def paste str
      @room.paste str
    end

    def topic str
      @room.topic = str
    end

  end
end
