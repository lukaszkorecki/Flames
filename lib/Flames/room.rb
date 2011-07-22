module Flames
  class Room

    attr_accessor :on_display, :on_listen, :after_listen

    def initialize room
      @room = room
      @room.join true
      # callbacks
      @on_listen = lambda {|m| puts "#{m['user']['name'].green} - #{m['body']}" }
      @on_display = lambda { |message, room| puts message }
      @after_listen = lambda { |message, room| }

    end

    def latest_messages
      @room.transcript(today).reject{|m| m[:message].nil? }.map do |message|
        {
          'type' => 'TextMessage',
          'body' => message[:message].to_s,
          'user' => {
            'name' => message[:user_id].to_s
          }
        }
      end
    end

    def display
      Thread.new do
        @room.listen do |m|
          @on_listen.call m
          @after_listen.call m, @room
        end
      end
      @on_display.call "hi!", @room
    end

    def post str
      @room.speak str
    end

    alias :speak :post

    def paste str
      @room.paste str
    end

    def topic str
      @room.topic = str
    end


    def today
      require 'ostruct'
      o = OpenStruct.new
      o.to_date = Time.now
    end
  end
end
