module Flames
  class Room

    attr_accessor :on_join, :on_listen, :after_listen

    def initialize room
      @room = room
      # callbacks
      @on_join = lambda { |message, room| puts "on_join #{message}"}
      @on_listen = lambda {|m| puts "#{m['user']['name'].green} - #{m['body']}" }
      @after_listen = lambda { |message, room| puts "after_listen #{message}" }

    end

    def join
      @room.join true
      @on_join.call "hi!", @room
    end

    def latest_messages
      users = {}.tap do |h|
        @room.users.each do |u|
          h[ u['id'].to_s] = u['name']
        end
      end

      transcript = @room.transcript(today).reject{|m| m[:message].nil? }.map do |message|
        {
          'type' => 'TextMessage',
          'body' => message[:message].to_s,
          'user' => {
          'name' => users[message[:user_id].to_s]
        }
        }
      end
      @after_listen.call '', @room
      transcript
    end

    def display
      @room.listen do |m|
        @on_listen.call m
        @after_listen.call m, @room
      end
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
