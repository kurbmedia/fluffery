$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rubygems'
require 'bundler'
Bundler.setup

require 'rspec'
require 'active_support'
require 'action_pack'
require 'action_view'
require 'action_controller'
require 'rails/railtie'

require File.expand_path(File.join(File.dirname(__FILE__), '../lib/fluffery'))
#Dir["#{File.dirname(__FILE__)}/**/*.rb"].sort.each{ |f| require f }