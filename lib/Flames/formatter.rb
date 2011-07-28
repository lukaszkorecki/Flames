module Flames
  class Formatter
    def time
      [:hour, :min, :sec].map { |m| Time.now.send m }.join ':'
    end

    def random_color str
      colors =  [:red, :green, :dark_green, :yellow, :blue, :dark_blue, :pur]
      str.send colors.sample
    end

    def format m
      case m['type']
      when 'TimestampMessage'
        "< #{time.green} >"

      when 'TextMessage'
        "<#{random_color m['user']['name']}> #{m['body']}"

      when 'PasteMessage'
        s = "<#{random_color m['user']['name']}>"
        s << "\n\n"
        s << "-"*20
        s << m['body']
        s << "-"*20

      when 'KickMessage'
        s = "< "
        s << "#{random_color m['user']['name']} left the room".dark_green
        s << " >"

      when 'EnterMessage'
        s = "< "
        s << "#{random_color m['user']['name']} joined the room".dark_green
        s << " >"

      else
        "Unknown type! \n#{m.to_yaml}"
      end
    end

  end
end
