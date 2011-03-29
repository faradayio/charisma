require 'action_pack'
require 'action_pack/version'
%w{
  action_view/helpers/number_helper
}.each do |action_pack_3_requirement|
  require action_pack_3_requirement
end if ActionPack::VERSION::MAJOR == 3

module Charisma
  class NumberHelper
    extend ActionView::Helpers::NumberHelper
    
    def self.delimit(number)
      number_with_delimiter number, :delimiter => ",", :separator => "."
    end
  end
end
