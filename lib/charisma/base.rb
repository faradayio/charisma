module Charisma
  module Base
    def characteristics
      @curator ||= Hash.new.extend(Curator).init(self)
    end
  end
  
  class InvalidMeasurementError < StandardError; end
end
