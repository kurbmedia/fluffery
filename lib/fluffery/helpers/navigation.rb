module Fluffery
  module Helpers
    module Navigation
      
      # Creates a navigation link (by default a list item) that has the class 'on' if we are on that particular page or a
      # page beneath it.
      # Example: nav_link_to('Blog', 'blog') will have the class of 'on' should we be on /blog or /blog/some_path 

      def nav_link_to(txt, path, attrs = {}, wrapper = :li)

        path_validation = false
        path_validation = attrs.has_key?(:proc) ? attrs[:proc].call(path) : (request.path == path || request.path.match(/#{path}\/.*/i)) 
        path_validation = request.path.match(/#{attrs[:matcher].gsub("_path", path)}/i)   if attrs.has_key?(:matcher)
        attrs.delete(:proc)
        attrs.delete(:matcher)
        
        wrapper_attrs = attrs.delete(:wrapper)
        attrs, wrapper_attrs = merge_html_classes(attrs, path_validation), merge_html_classes(wrapper_attrs, path_validation)
        
        return_val = link_to_unless(path_validation, txt, path, attrs) do
          link_to(txt, path, attrs)
        end

        (wrapper.eql? false) ? return_val : content_tag(wrapper, return_val, wrapper_attrs)

      end
      
      # Creates a nested navigation block, generally used for lists/nested lists.
      def navigation(txt, path, attrs = {}, options = {}, &block)
        options.reverse_merge!(:container => :ol, :wrapper => :li)        
        navigation_content = content_tag(options[:container], capture(&block))
        wrapper_attrs = attrs.delete(:wrapper)
        parent_link        = nav_link_to(txt, path, attrs, false)
        content_tag(options[:wrapper], "#{parent_link}\n#{navigation_content}".html_safe, (wrapper_attrs || {}))        
      end
      
      private
      
      def merge_html_classes(attrs, add_on = false)
        attrs ||= {}
        Fluffery::Utils::Internal.merge_html_classes(attrs, 'on') if add_on
        attrs
      end
      
    end
  end
end