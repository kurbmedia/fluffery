module Fluffery
  module Forms
    module Validation
      
      class Presence < Fluffery::Forms::Validation::Base        
        def self.create(attribute ,options)
          options.merge!('required' => 'required') unless options.has_key?('required') && options['required'] === false          
          options
        end        
      end
      
      class Pattern < Fluffery::Forms::Validation::Base
        def self.create(attribute, options, matcher)
          options.reverse_merge!('pattern' => matcher.source) unless matcher.nil?
          options
        end        
      end
      
    end
  end
end