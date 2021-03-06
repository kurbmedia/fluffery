module Fluffery
  module Forms
    
    class Builder < ActionView::Helpers::FormBuilder
      
      include Fluffery::Forms::Utilities
      
      # Access the template object, and create an accessor which will track the order
      # in which our fields are used in the form. This way we have the ability to capture that state for re-use in emails etc.
      attr_accessor :template, :field_order
      
      # Sets up options custom to our form builder.
      # It also overrides the default error proc so we can use something more custom.
      #
      def initialize(object_name, object, template, options, proc)        
        @field_order ||= []        
        without_error_proc do
          super(object_name, object, template, options, proc)          
        end        
        
      end
      
      # Creates a html button tag for use in forms instead of the default input submit.
      # Uses a span to wrap the content so it can be styled with css.
      #
      def button(value = nil, options = {})
        value, options = nil, value if value.is_a?(Hash)
        value ||= submit_default_value
        
        options = confirm_or_disable(options)        
        options = Fluffery::Utils::Internal.merge_html_classes(options, 'button')

        content_tag(:button, options.reverse_merge!({ "type" => "submit", "name" => "commit" })) do
          content_tag(:span, value.to_s)
        end

      end
      
      # Custom label tag including an asterisk if the field is required.
      #
      def label(method, text = nil, options = {}, &block)

        options, text = text, nil if text.is_a?(Hash)
        text ||= method.to_s.humanize
        options.stringify_keys!
        
        options.reverse_merge!('transform' => :titleize) unless option_exists?(options['transform'])
        text.send(options['transform'].to_sym)
        options.delete('transform')
        
        # Check to see if :required is set on a label, or if the attribute/method has a validator that require it exists. 
        # If so, add a * to the label.
        text = "#{text} <abbr title='Required'>*</abbr>".html_safe if validator.attribute_required?(method, options)
        super(method, text, options, &block)

      end
      
      def email_field(method, options = {})
        render_with_fluff(method, options) do
          super(method, options.merge!('type' => 'email'))
        end
      end
      
      # Renders the default date_select but with an error wrapping if 
      # the method in question has errors
      #
      def date_select(method, options = {}, html_options = {})
        render_with_fluff(method, options, html_options) do
          super(method, options, html_options)
        end        
      end
      
      # HTML5 Number field, again, falls back to text in unsupportive browsers.
      #
      def number_field(method, range, options = {})
        options, range = range, nil if range.is_a?(Hash)
        options.stringify_keys!
        unless range.nil?
          range = (range.is_a?(Range)) ? range.to_a : range
          options.merge!('min' => range.first, 'max' => range.last)
        end
        
        render_with_fluff(method, options) do
          super(method, options.merge!('type' => 'number'))
        end
        
      end
      
      def password_field(method, options = {})
        render_with_fluff(method, options) do
          super(method, options)
        end
      end
      
      def select(method, choices, options = {}, html_options = {})
        render_with_fluff(method, options, html_options) do
          @template.select(@object_name, method, choices, options, html_options)
        end
      end
      
      def state_select(method, options = {}, html_options = {})
        
        state_options = [['Please Select',nil]]
        state_options << ['International', (int || 'International')] if int = options.delete(:international)
        [
            ['Alabama', "AL"],['Alaska', "AK"],['Arizona', "AZ"],['Arkansas', "AR"],['California', "CA"],['Colorado', "CO"],
          	['Connecticut', "CT"],['District of Columbia', "DC"],['Delaware', "DE"],['Florida', "FL"],['Georgia', "GA"],
          	['Hawaii', "HI"],['Idaho', "ID"],['Illinois', "IL"],['Indiana', "IN"],['Iowa', "IA"],['Kansas', "KS"],['Kentucky', "KY"],
          	['Louisiana', "LA"],['Maine', "ME"],['Maryland', "MD"],['Massachusetts', "MA"],['Michigan', "MI"],['Minnesota', "MN"],
          	['Mississippi', "MS"],['Missouri', "MO"],['Montana', "MT"],['Nebraska', "NE"],['Nevada', "NV"],['New Hampshire', "NH"],
          	['New Jersey', "NJ"],['New Mexico', "NM"],['New York', "NY"],['North Carolina', "NC"],['North Dakota', "ND"],
          	['Ohio', "OH"],['Oklahoma', "OK"],['Oregon', "OR"],['Pennsylvania', "PA"],['Rhode Island', "RI"],['South Carolina', "SC"],
          	['South Dakota', "SD"],['Tennessee', "TN"],['Texas', "TX"],['Utah', "UT"],['Vermont', "VT"],['Virginia', "VA"],['Washington', "WA"],
          	['West Virginia', "WV"],['Wisconsin', "WI"],['Wyoming', "WY"]
        ].each do |state|
          should_abbr = options.delete(:abbreviate)
          state_options << (should_abbr ? state : [state.first, state.first])
        end
        
        select(method, @template.options_for_select(state_options, @object.try(:state)), options, html_options)
        
      end
      
      def text_field(method, options = {})
        render_with_fluff(method, options) do
          super(method, options)
        end
      end
      
      def text_area(method, options = {})
        render_with_fluff(method, options) do
          super(method, options)
        end
      end

      def url_field(method, options = {})
        render_with_fluff(method, options) do
          super(method, options.merge!('type' => 'url'))
        end
      end  
      
    end
    
  end
end