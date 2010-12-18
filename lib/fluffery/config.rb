module Fluffery
  
  class Config
    
    def self.forms
      @forms ||= {
        :error_class         => 'field_with_errors',
        :message_error_class => 'errors_for_field',
        :error_template      => %{
              <span class="<%= error_class %>">
                   <%= html_tag %>
                   <span class="<%= message_error_class %>"><%= [messages].flatten.join(",") %></span>
              </span>
            }
          }
    end
    
    def self.dom
      @dom ||= {}
    end
    
    def initialize
      yield Fluffery::Config if block_given?
    end
    
    
  end
  
end