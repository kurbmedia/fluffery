require 'erb'
require 'fluffery/forms/validation/base'

module Fluffery
  module Forms
    
    module Utilities
      
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
      
      # Generate additional options on our fields.
      # 1. If a field has errors, wrap it with the defined error template.
      # 2. Also add our error class to the field itself.
      #
      def render_with_fluff(method, options, html_options = nil, &block)        
        options = validator.add_html_attributes(method, options)        
        # If no errors, simply return.
        unless validator.errors_for?(method)
          return block.call
        end
        
        configs     = Fluffery::Config.forms
        template    = configs[:error_template]
        error_class = configs[:error_class]
        options     = Fluffery::Utils::Internal.merge_html_classes(options, error_class)
        
        # Capture the original html tag with any updated options.
        html_tag = block.call
        return html_tag if template.nil? or template.blank?
        
        renderer            = ERB.new(template, 0, "%<>")        
        messages            = @object.errors[method.to_sym]        
        message_error_class = configs[:message_error_class]
        renderer.result.to_s.html_safe
        
      end
      
      def validator
        @validator ||= Fluffery::Forms::Validation::Base.new(@object)
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