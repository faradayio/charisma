module Charisma
  # This module is included in characterized objects (via <tt>include Charisma</tt> on the class)
  module Base
    # The accessor for the object's characteristics, which can be treated more or less like a Hash.'
    def characteristics
      @curator ||= Curator.new(self)
    end
  end
  
  # Poorly-defined measurements raise this error.
  class InvalidMeasurementError < StandardError; end
end
