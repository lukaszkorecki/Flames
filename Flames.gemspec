# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "Flames/version"

Gem::Specification.new do |s|
  s.name        = "Flames"
  s.version     = Flames::VERSION
  s.authors     = ["Łukasz Korecki"]
  s.email       = ["lukasz@coffeesounds.com"]
  s.homepage    = ""
  s.summary     = %q{Campfire flamewars in your terminal}
  s.description = %q{Flames is a terminal client for 37Signals' Campifre}

  s.rubyforge_project = "Flames"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'tinder'
  s.add_dependency 'highline'
end
