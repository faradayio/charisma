require 'active_support'
require 'active_support/version'
%w{
  active_support/inflector/methods
  active_support/core_ext/class/attribute_accessors
  active_support/core_ext/string/output_safety
}.each do |active_support_3_requirement|
  require active_support_3_requirement
end if ActiveSupport::VERSION::MAJOR == 3

require 'blockenspiel'
require 'conversions'

require 'charisma/base'
require 'charisma/base/class_methods'
require 'charisma/characteristic'
require 'charisma/characterization'
require 'charisma/measurement'
require 'charisma/measurement/length'
require 'charisma/curator'
require 'charisma/curator/curation'
require 'charisma/number_helper'

module Charisma
  def self.included(base)
    base.send :include, Base
    base.extend Base::ClassMethods
  end
end
