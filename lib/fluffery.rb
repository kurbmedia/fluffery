require 'fluffery/railtie'

module Fluffery
  
  autoload :Config, 'fluffery/config'
  
  module Forms
    autoload :Builder,   'fluffery/forms/builder'
    autoload :Utilities, 'fluffery/forms/utilities'
  end
  
  module Helpers
    autoload :Navigation,    'fluffery/helpers/navigation'
    autoload :PageVariables, 'fluffery/helpers/page_variables'
    autoload :Elements,      'fluffery/helpers/elements'
    autoload :Includes,      'fluffery/helpers/includes'
  end
  
  module Utils
    autoload :Internal, 'fluffery/utils/internal'
  end
  
end