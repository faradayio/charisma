require 'active_support'
require 'active_support/version'
if ActiveSupport::VERSION::MAJOR >= 3
  require 'active_support/inflector/methods'
  require 'active_support/core_ext/class/attribute_accessors'
  require 'active_support/core_ext/string/output_safety'
  require 'active_support/core_ext/object/try'
end 

require 'blockenspiel'
require 'conversions'

require 'charisma/base'
require 'charisma/base/class_methods'
require 'charisma/characteristic'
require 'charisma/characterization'
require 'charisma/measurement'
require 'charisma/measurement/length'
require 'charisma/measurement/mass'
require 'charisma/measurement/speed'
require 'charisma/measurement/time'
require 'charisma/curator'
require 'charisma/curator/curation'
require 'charisma/number_helper'

# Charisma provides a <em>superficiality framework</em> for Ruby objects.
#
# You can use it to:
#
#  * Provide a <em>curation strategy</em> for your class that defines which of its attributes are <em>superfically important.</em>
#  * Define <em>metadata</em> on these characteristics, such as measurements and units.
#  * Facilitate <em>appropriate presentation</em> of these characteristics (i.e., intelligent <tt>#to_s</tt>).
module Charisma
  # Prepare a class for characterization with <tt>include Charisma</tt>.
  def self.included(base)
    base.send :include, Base
    base.extend Base::ClassMethods
  end
end

Conversions.register :metres, :feet, 3.2808399
