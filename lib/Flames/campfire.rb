module Flames
  class Campfire
    def initialize conf_file="~/.flames"
      begin
        conf = YAML::load_file File.expand_path conf_file
      rescue => e
        puts "ERROR".red
        puts "error loading #{conf_file}"
        exit 1
      end
      begin
        @campfire = ::Tinder::Campfire.new conf['domain'], :token => conf['key']
        @rooms = rooms
      rescue
        puts "ERROR".red
        puts "Could not connect to server"
        exit 1
      end
    end

    def rooms
      @campfire.rooms.map {|r| r.name }
    end

    def select_room name
      begin
        Room.new @campfire.find_room_by_name name
      rescue => e
        puts "ERROR".red
        puts e.inspect
        exit 1
      end
    end

  end
end
