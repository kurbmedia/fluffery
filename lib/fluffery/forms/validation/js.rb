module Fluffery
  module Forms
    module Validation
      class Js
      
        attr_accessor :object, :data
      
        # The JS classes build JSON based validation data for model based forms.
        # This allows easier integration with javascript valiation libraries.
        #
        def initialize(object)
          @object = object
          @data ||= {}
        end
        
        def add!(method, type, vattr)
          @data[method] ||= {}
          @data[method].merge!('required' => true) and return self if type.to_s.eql?('required')
          @data[method].merge!(type => vattr)
          return self
        end
        
        def to_json
          @data.to_json
        end
      
      end
    end
  end
end