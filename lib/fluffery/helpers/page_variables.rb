module Fluffery
  module Helpers
    
    module PageVariables
      
      def page_default(param, data = nil)
        create_variable("helpful_#{param}", data) unless data.nil? or data.blank?
      end
      
      def page_id(content = nil)
        create_internal_variable(:helpful_page_id, content) and return unless content.nil?
        return retrieve_variable(:helpful_page_id) if content_for?(:helpful_page_id)
        cname = controller.class.to_s.gsub(/controller$/i,'').underscore.split("/").join('_')
        aname = controller.action_name
        "#{cname}_#{aname}"
      end
            
      def page_title(content = nil)
        (content.nil?) ? retrieve_variable(:helpful_page_title) : create_internal_variable(:helpful_page_title, content)
      end
      
      def keywords(content = nil)
        (content.nil?) ? retrieve_variable(:helpful_keywords) : create_internal_variable(:helpful_keywords, content)
      end
      
      def description(content = nil)
        (content.nil?) ? retrieve_variable(:helpful_description) : create_internal_variable(:helpful_description, content)
      end
      
      def create_variable(var, content, new_method = true)
        content_for(var.to_sym) do
          content
        end                        
        self.class_eval{ define_method("#{var.to_s}"){ retrieve_variable(var.to_sym) } } if new_method
        return ""
      end
      
      private
      
      def create_internal_variable(var, content)
        create_variable(var, content, false)
      end
      
      def retrieve_variable(var)
        (content_for?(var.to_sym) ? content_for(var.to_sym) : "")
      end
      
    end
    
  end
end