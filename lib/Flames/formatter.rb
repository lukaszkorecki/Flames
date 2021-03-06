module Flames
  class Formatter
    def initialize
      @colors =  [:red, :green, :dark_green, :yellow, :blue, :dark_blue, :pur]
    end

    def time
      [:hour, :min, :sec].map { |m| Time.now.send m }.join ':'
    end

    def random_color str

      if str.nil?
        ""
      else
        str.send @colors.sample
      end
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

      when 'TweetMessage'
        s = "<#{random_color m['user']['name']}> shares a #{'tweet'.blue}:\n"
        s << m['tweet']['message']
        s << "\n@#{m['tweet']['author_username']}\n"
        s << "http://twitter.com/#!/#{m['tweet']['author_username']}/status/#{m['tweet']['id']}".blue

      when 'UploadMessage'
        s = "< "
        s << "#{random_color m['user']['name']} uploaded a file".yellow
        s << " >"

      else
        "Unknown type! \n#{m.to_yaml}"
      end
    end

  end
end
