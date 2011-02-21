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
          options.reverse_merge!(default_messages_for(attribute))
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
        
        # Looks up the default error message so it may be used in our data-message attribute
        #
        def default_messages_for(attribute)
          validators   = validators_for(attribute)
          message_data = validators.inject({}) do |hash, validator|
            message = validator.options.has_key?(:message) ? validator.options[:message] : MessageBuilder.message_for(@object, attribute, validator)
            hash.merge!(validator.kind.to_s => message)
          end
          {'data-validation-messages' => CGI::escape(message_data.to_json), 'data-validators' => validators.collect{ |v| v.kind.to_s }.join(' ') }
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
          validators = @object.class.validators_on(attribute).uniq
        end
        
        def validators_for?(method)
          !validators_for(method).empty?
        end
        
      end
      
      class MessageBuilder
        def self.message_for(object, attribute, validator)
          message = self.get_validation_message(validator)
          message = self.defaults(validator.kind) unless message.match(/translation missing/i).nil?
          message
        end
        
        private
        
        def self.defaults(validator)
          {
            :presence     => "required",
            :format       => 'invalid',
            :length       => "wrong length",
            :numericality => "not a number",
            :uniqueness   => 'taken',
            :confirmation => 'required',
            :acceptance   => 'required',
            :inclusion    => 'invalid',
            :exclusion    => 'invalid'
          }[validator]
        end
        
        def self.get_validation_message(validator)
          key = {
            :presence     => "blank",
            :format       => 'invalid',
            :length       => self.length_options(validator.options),
            :numericality => self.numericality_options(validator.options),
            :uniqueness   => 'taken',
            :confirmation => 'confirmation',
            :acceptance   => 'accepted',
            :inclusion    => 'inclusion',
            :exclusion    => 'exclusion'
          }[validator.kind]
          key.is_a?(Array) ? I18n.translate("errors.messages.#{key.first}").sub("%{#{:count}}", key.last.to_s) : I18n.translate("errors.messages.#{key}")
        end

        def self.length_options(opts)
          if count = opts[:is]
            ["wrong_length", count]
          elsif count = opts[:minimum]
            ["too_short", count]
          elsif count = opts[:maximum]
            ["too_long", count]
          end
        end

        def self.numericality_options(opts)
          if opts[:only_integer]
            'not_a_number'
          elsif count = opts[:greater_than]
            ['greater_than', count]
          elsif count = opts[:greater_than_or_equal_to]
            ['greater_than_or_equal_to', count]
          elsif count = opts[:less_than]
            ['less_than', count]
          elsif count = opts[:less_than_or_equal_to]
            ['less_than_or_equal_to', count]
          elsif opts[:odd]
            'odd'
          elsif opts[:even]
            'even'
          else
            'not_a_number'
          end
        end
        
      end
      
    end
  end
end