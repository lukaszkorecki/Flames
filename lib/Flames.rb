if RUBY_VERSION.split('.')[1].to_i < 9
  puts "Flames requires ruby 1.9.2"
  exit 1
end

require 'rubygems'
require 'bundler'

Bundler.require

require 'yaml'

require 'Flames/campfire'
require 'Flames/room'
require "Flames/version"
