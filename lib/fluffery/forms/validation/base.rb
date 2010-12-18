module Fluffery
  module Forms
    module Validation
      
      class Base
        
        require 'fluffery/forms/validation/validators'
        
        attr_accessor :object
        
        def initialize(form_object)
          @object = form_object
        end
        
        def add_html_attributes(attribute, options)
          options = Presence.create(attribute, options) if attribute_required?(attribute)
          matcher = attribute_format_validator(attribute)
          options = Pattern.create(attribute, options, matcher) unless matcher.nil?
          options
        end
        
        # Checks to see if the particular attribute is required, used primarily on labels.
        #
        def attribute_required?(attribute, options = nil)
          options.stringify_keys! if options.is_a?(Hash)
          unless options.nil?
            return true if options.has_key?('required') and options['required'] === true
          end
          valid_items = validators_for(attribute).find do |validator| 
            ([:presence, :inclusion].include?(validator.kind)) && 
            (validator.options.present? ? options_require_validation?(validator.options) : true)
          end        
          !valid_items.nil?        
        end
        
        # Checks to see if a particular attribute contains a Regex format validator
        #
        def attribute_format_validator(attribute)          
          format_validator = validators_for(attribute).detect{ |v| v.kind == :format }
          return nil unless !format_validator.nil?
          return nil unless format_validator.options.has_key?(:with) && format_validator.options[:with].is_a?(Regexp)
          matcher = format_validator.options[:with]
        end

        # Checks to see if the particular attribute has errors
        #
        def errors_for?(method)
          !(@object.nil? || @object.errors.empty? || !@object.errors.key?(method.to_sym) || [@object.errors[method.to_sym]].flatten.empty?)
        end

        # Checks to see if the validation is required
        # Courtesy Justin French and Formtastic
        #
        def options_require_validation?(options)
          allow_blank = options[:allow_blank]
          return !allow_blank unless allow_blank.nil?
          if_condition = !options[:if].nil?
          condition = if_condition ? options[:if] : options[:unless]

          condition = if condition.respond_to?(:call)
            condition.call(@object)
          elsif condition.is_a?(::Symbol) && @object.respond_to?(condition)
            @object.send(condition)
          else
            condition
          end

          if_condition ? !!condition : !condition
        end

        # Finds all existing validations for the current object and method
        #
        def validators_for(attribute)
          return [] unless !@object.nil? and @object.class.respond_to?(:validators_on)
          attribute  = attribute.to_s.sub(/_id$/, '').to_sym
          validators = @object.class.validators_on(attribute).collect{ |validator| validator }.uniq
        end
        
        def validators_for?(method)
          !validators_for(method).empty?
        end
        
      end
      
    end
  end
end