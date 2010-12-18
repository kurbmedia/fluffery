module Fluffery
  module Utils
    
    class Internal
    
      # Merge any new classes with existing html classes
      #
      def self.merge_html_classes(options, classes)
        classes = [classes].flatten
        options.stringify_keys!
        return options.merge!('class' => classes.join(' ')) unless options.has_key?('class')
        old_classes = options['class'].split(' ')
        options.merge!('class' => [classes, old_classes].flatten.join(' '))
      end
    
    end
    
  end  
end