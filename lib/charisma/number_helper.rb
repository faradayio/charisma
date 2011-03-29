require 'action_pack'
require 'action_view'

module Charisma
  class NumberHelper
    extend ActionView::Helpers::NumberHelper
    
    def self.delimit(number)
      number_with_delimiter number, :delimiter => ",", :separator => "."
    end
  end
end
