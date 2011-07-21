if RUBY_VERSION.split('.')[1].to_i < 9
  puts "Flames requires ruby 1.9.2"
  exit 1
end

require 'yaml'
require "Flames/version"
