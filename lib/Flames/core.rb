module Flames
  class Core
    def initialize conf_file="~/.flames"
      begin
        conf = YAML::load_file File.expand_path conf_file
      rescue => e
        puts "error loading #{conf_file}"
        exit 1
      end
      begin
        @campfire = ::Tinder::Campfire.new conf['domain'], :token => conf['key']
      rescue => e
        puts "Error".red
        puts "Could not connect to Campfire for given #{conf['domain']}"
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
        puts "error".red
        puts e.inspect
        exit 1
      end
    end

  end
end
