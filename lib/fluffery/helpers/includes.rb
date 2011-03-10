module Fluffery
  module Helpers
    
    module Includes
      
      # Wraps output in IE conditional tags, the condition should be specified in the same
      # format as it would in the conditional itself. For example:
      # ie_conditional('lte IE 8') yields [if lte IE 8]
      #
      def ie_conditional(condition, &block)
        output = ["<!--[if #{condition}]>"]
        output << capture(&block)
        output << "<![endif]-->"
        output.join("\n").html_safe
      end
      
    end
    
  end
end