module Fluff
  module Generators
    
    class JavascriptsGenerator < Rails::Generators::Base
      
      desc "Add various javascript files to your public/javascripts folder."
      
      argument :scope, :required => false, :default => nil, 
               :desc => "The specific javascript packages to add. Leave this option off to include all."
      
      def copy_javascripts
        unless scope
          directory 'javascripts', 'public/javascripts'
        end
      end
      
    end
    
  end
end