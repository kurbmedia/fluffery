module Fluffery
  module Helpers
    
    module Elements
      
      # Creates a common format for CSS buttons
      # Example: button_link('Blog', '/blog') yields <a href="/blog" class="button"><span>Blog</span></a>

      def button_link(txt, path, attrs = {})
        inline_classes = attrs.has_key?(:class) ? "#{attrs[:class]} " : ""
        link_to "<span>#{txt}</span>".html_safe, path, attrs.merge({ :class => "#{inline_classes}button" })    
      end
      
      # Outputs all flash messages. This allows you to call <%= flash_messages %> once in your
      # application's layout file. The output is a div with the class flash_message, and the type used. It also renders
      # a "close" tag, which can be overridden or set to "". By default this is a span containing 'X'
      #
      # <div class="flash_message error">
      #      Your error message from flash[:error]
      #      <span>X</span>
      #  </div>
      #
      #
      def flash_messages(attrs = {})
        wrapper = attrs.delete(:wrapper) || :div
        closer  = attrs.delete(:close) || "<span>X</span>"
        classes = (attrs.key?(:class)) ? attrs[:class].split(' ') : []
        classes << "flash_message"  
        content = ""    
        flash.each_key do |k|
          classes << "flash_message_#{k.to_s.underscore}"
          msg_attrs = attrs.merge(:class => [k.to_s, classes].flatten.join(' '))
          content.concat content_tag(wrapper, "#{flash[k]} #{closer}".html_safe, msg_attrs).html_safe
        end    
        content.html_safe    
      end
      
    end
    
  end
end