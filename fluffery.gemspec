# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fluffery/version"

Gem::Specification.new do |s|
  
  s.name        = "fluffery"
  s.version     = Fluffery::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["kurb media"]
  s.date        = %q{2011-03-10}  
  s.email       = %q{info@kurbmedia.com}
  s.homepage    = %q{http://github.com/kurbmedia/fluffery}
  s.licenses    = ["MIT"]
  s.summary     = %q{ummm.. Adds misc fluffery to yer apps.}
  s.description = %q{Random fluffage for Rails applications.}

  s.rubyforge_project = "fluffery"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency(%q<rails>, ["~> 3.0.0"])
  s.add_dependency(%q<actionpack>, ["~> 3.0.0"])
  s.add_development_dependency(%q<rspec>, ["~> 2.3"])
  s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
  
  
end
