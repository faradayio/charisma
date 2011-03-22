require 'active_support'
require 'active_support/version'
%w{
  active_support/inflector/methods
  active_support/core_ext/class/attribute_accessors
}.each do |active_support_3_requirement|
  require active_support_3_requirement
end if ActiveSupport::VERSION::MAJOR == 3

require 'blockenspiel'

require 'charisma/base'
require 'charisma/base/class_methods'
require 'charisma/characteristic'
require 'charisma/characterization'
require 'charisma/measurement'
require 'charisma/curator'
require 'charisma/curator/curation'


module Charisma
  def self.included(base)
    base.send :include, Base
    base.extend Base::ClassMethods
  end
end
