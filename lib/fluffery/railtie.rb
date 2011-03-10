module Fluffery
  class Railtie < Rails::Railtie
        
    initializer :after_initialize do
      # Configure ActionView with any addons.
      ActionView::Base.send :include, Fluffery::Helpers::Navigation
      ActionView::Base.send :include, Fluffery::Helpers::PageVariables
      ActionView::Base.send :include, Fluffery::Helpers::Elements
      ActionView::Base.send :include, Fluffery::Helpers::Includes
      ActionView::Base.send :default_form_builder=, Fluffery::Forms::Builder
    end
    
  end
end