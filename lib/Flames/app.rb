#!/usr/bin/env ruby
require 'ncurses'

# based on: https://github.com/PaulOstazeski/presently-cli

module Flames
  class App
    attr_accessor :update_proc, :post_proc, :buffer

    def initialize
      @buffer = []
      @output_window = @input_window = nil

      @update_proc = lambda {}
      @post_proc = lambda {}
    end

    def start
      Ncurses.initscr
      Ncurses.cbreak
      Ncurses.noecho
      Ncurses.curs_set 0
      create_or_resize_windows

      @output_thread = Thread.new do
        loop do
          get_messages
          update_output
          sleep 5
        end
      end
      @input_thread  = Thread.new { update_input }

      [ @input_thread, @output_thread ].map { |thr| thr.join }

      Ncurses.nl
      Ncurses.echo
      Ncurses.nocbreak
      Ncurses.curs_set 1
      Ncurses.endwin
    end

    def create_or_resize_windows
      separator = 5
      lines = Ncurses.LINES()
      @output_window = Ncurses::WINDOW.new lines - separator, 0, 0, 0
      @input_window  = Ncurses::WINDOW.new separator, 0 ,lines - separator, 0

      [@input_window, @output_window].map { |win| win.box 0,0; win.noutrefresh }

      @output_window = @output_window.derwin @output_window.getmaxy-2, @output_window.getmaxx-2, 1, 1
      @input_window  = @input_window.derwin  @input_window.getmaxy-2, @input_window.getmaxx-2, 1, 1

      [@input_window, @output_window].map { |win| win.idlok true; win.scrollok true; win.noutrefresh }
    end

    def update_output
      @output_window.erase
      @buffer.each { |t| @output_window.addstr t }
      @output_window.noutrefresh
      Ncurses.doupdate
    end

    def update_input
      msg = ''
      @input_window.keypad true
      loop do
        Ncurses.doupdate
        @input_window.erase

        @input_window.addstr "Say> #{msg}"

        @input_window.noutrefresh

        letter = @input_window.getch
        case letter
          when ?\n, ?\r
            post_message "#{msg}"
            msg = ''
            @output_thread.wakeup
          when ?
            msg.chop!
          when Ncurses::KEY_RESIZE
            create_or_resize_windows
            @output_thread.wakeup
          when Ncurses::KEY_UP,Ncurses::KEY_RIGHT,Ncurses::KEY_LEFT,Ncurses::KEY_DOWN
            nil
          else
            msg << letter
        end
      end
    end

    def post_message(msg)
      return @post_proc.call msg
    end

    def get_messages
      messages = [@buffer].flatten.map { |e| "#{e}\n" }
      @messages += messages
      @messages.shift until 100 > @messages.size
    end

  end
end

Flames::App.new
