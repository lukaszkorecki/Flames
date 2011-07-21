module Flames
  class Campfire
    def initialize conf_file="~/.flames"
      begin
        conf = YAML::load_file File.expand_path conf_file
      rescue => e
        puts "error loading #{conf_file}"
        exit 1
      end
      @campfire = ::Tinder::Campfire.new conf['domain'], :token => conf['key']
    end

    def rooms
      puts @campfire.rooms.map {|r| r.name }.join "\n"
    end

    def join_room name
      Room.new @campfire.find_room_by_name name
    end
  end
end
