module Charisma
  module Base
    def characteristics
      @curator ||= Curator.new(self)
    end
  end
  
  class InvalidMeasurementError < StandardError; end
end
