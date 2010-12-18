module Fluff
  module Generators
    
    class FluffGenerator < Rails::Generators::Named

      namespace "fluff"
      source_root File.expand_path("../templates", __FILE__)
      
      desc "Various generators to add some fluffery to your Rails app."
      
    end
    
  end
end