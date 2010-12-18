require 'erb'

module Fluffery
  module Forms
    
    module Utilities
      
      # Checks to see if the particular attribute is required, used primarily on labels.
      #
      def attribute_required?(method, options = nil)
        options.stringify_keys! if options.is_a?(Hash)
        unless options.nil?
          return true if options.has_key?('required') and options['required'] === true
        end
        !validators_for(method).find{ |validator| ([:presence, :inclusion].include?(validator.to_sym)) && (validator.options.present? ? options_require_validation?(validator.options) : true)}.nil?
      end
      
      # Checks to see if the particular attribute has errors
      #
      def attribute_has_errors?(method)
        !(@object.nil? || @object.errors.empty? || !@object.errors.key?(method.to_sym) || [@object.errors[method.to_sym]].flatten.empty?)
      end
      
      # Simply shortening calls to content_tag since it is a method of @template
      #
      def content_tag(tag, content, options = {}, escape = true, &block)
        @template.content_tag(tag, content, options, escape, &block)
      end
      
      # Adds data-confirm, or data-disable-with if set.
      #
      def confirm_or_disable(options)
        options.stringify_keys!
        options.merge!("data-disable-with" => options["disable_with"]) if options.delete("disable_with")
        options.merge!("data-confirm" => options["confirm"]) if options.delete("confirm")
        options
      end
      
      # Allows us to call something like f.error_console to log form errors
      # to a javascript console such as firebug
      #
      def error_console
        "<script type=\"text/javascript\" charset=\"utf-8\">
        //<![CDATA[
            try{ console.log(\"#{@template.escape_javascript(@object.errors.inspect)}\")}catch(e){}
        //]]>
        </script>".html_safe
      end
      
      # Quick helper to see if an option is nil, blank, or false
      #
      def option_exists?(opt)
        !(opt.nil? || opt.to_s.blank? || opt.to_s === "false")
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
      
      # Generate additional options on our fields.
      # 1. If a field has errors, wrap it with the defined error template.
      # 2. Also add our error class to the field itself.
      #
      def render_with_fluff(method, options, html_options = nil, &block)
        
        # Add a pattern field if this method contains a format validator using a regex
        options = add_pattern_validator(method, options)
        
        # If no errors, simply return.
        unless attribute_has_errors?(method)
          return block.call
        end
        
        configs     = Fluffery::Config.forms
        template    = configs[:error_template]
        error_class = configs[:error_class]
        options     = Fluffery::Utilities::Internal.merge_html_classes(options, error_class)
        
        # Capture the original html tag with any updated options.
        html_tag = block.call
        return html_tag if template.nil? or template.blank?
        
        renderer            = ERB.new(template, 0, "%<>")        
        messages            = @object.errors[method.to_sym]        
        message_error_class = configs[:message_error_class]
        renderer.result.to_s.html_safe
        
      end
      
      # Finds all existing validations for the current object and method
      #
      def validators_for(method)
        return [] unless !@object.nil? and @object.class.respond_to?(:validators_on)
        attribute  = attribute.to_s.sub(/_id$/, '').to_sym
        validators = @object.class.validators_on(attribute).collect{ |validator| validator.kind }.uniq
      end
      
      # Adds a "pattern" attribute to the element if using a validates_format_of validator
      #
      def add_pattern_validator(method, options)
        validations = validators_for(method)
        return options unless validations.collect{ |v| v.to_sym }.include?(:format)
        validations.each do |validator|
          if validator.options.has_key?(:with) && !validator.options[:with].nil? && validator.options[:with].is_a?(Regex)
            options.merge!('pattern' => validator.options[:with])
            break
          end          
        end        
        options
      end
      
      # Override the default error proc for our forms, making sure to
      # set it back when we are finished to avoid compatibility issues.
      #
      def without_error_proc
        default_proc = ActionView::Base.field_error_proc
        ActionView::Base.field_error_proc = lambda{ |html_tag, instance| html_tag }
        yield        
        ActionView::Base.field_error_proc = default_proc
      end
      
    end
    
  end
end