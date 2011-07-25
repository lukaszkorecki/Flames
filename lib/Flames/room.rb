module Flames
  class Room

    attr_accessor :on_join, :on_listen, :after_listen

    def initialize room
      @room = room
      # callbacks
      @on_join = []
      @on_listen = []
      @after_listen = []

      # @test_on_listen = lambda {|m| puts "#{m['user']['name'].green} - #{m['body']}" }
      # @test_on_join = lambda { |message, room| puts "on_join #{message}"}
      # @test_after_listen = lambda { |message, room| puts "after_listen #{message}" }
    end

    def join
      @room.join true
      @on_join.each {|cb| cb.call "hi!", @room }
      yield if block_given?
    end

    def latest_messages
      users = {}.tap do |h|
        @room.users.each do |u|
          h[ u['id'].to_s] = u['name']
        end
      end

      transcript = begin
                     @room.transcript(today).reject{|m| m[:message].nil? }
                   rescue => e
                     puts "Error'd when loading transcript".red
                     puts e.to_yaml unless ENV['DEBUG'].nil?
                     []
                   end
      transcript.map! do |message|
        {
          'type' => 'TextMessage',
          'body' => message[:message].to_s,
          'user' => {
            'name' => users[message[:user_id].to_s]
          }
        }
      end

      @after_listen.each { |cb| cb.call '', @room }
      transcript
    end

    def display
      begin
        @room.listen do |m|
          @on_listen.each {|cb| cb.call m }
          @after_listen.each {|cb| cb.call m, @room }
        end
      rescue => e
        puts "Error'd when listening".red
        puts e.to_yaml unless ENV['DEBUG'].nil?
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
