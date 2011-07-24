module Flames
  class Formatter
    def time
      [:hour, :min, :sec].map { |m| Time.now.send m }.join ':'
    end

    def format m
      case m['type']
      when 'TimestampMessage'
        "< #{time.green} >"
      when 'TextMessage'
        "<#{m['user']['name'].yellow}> #{m['body']}"
      when 'PasteMessage'
        s = "<#{m['user']['name'].yellow}>"
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
        "Unknown type! \n#{m.to_yaml}"
      end
    end

  end
end
