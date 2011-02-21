require 'rubygems'
require 'bundler'
require "rake"
require "rake/rdoctask"
require "rspec"
require "rspec/core/rake_task"

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "fluffery"
  gem.homepage = "http://github.com/kurbmedia/fluffery"
  gem.license = "MIT"
  gem.summary = %Q{ummm.. Adds misc fluffery to yer apps.}
  gem.description = %Q{Because sometimes you just need to add a little fluff to make it awesome.}
  gem.email = "brent@kurbmedia.com"
  gem.authors = ["Brent Kirby"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

Rspec::Core::RakeTask.new("spec:unit") do |spec|
  spec.pattern = "spec/unit/**/*_spec.rb"
end

Rspec::Core::RakeTask.new("spec:integration") do |spec|
  spec.pattern = "spec/integration/**/*_spec.rb"
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fluffery #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
