module Charisma
  class Measurement
    attr_reader :value
    
    def initialize(value)
      @value = value
    end

    def to_s
      "#{NumberHelper.delimit value} #{u}"
    end
    
    def to_f
      value.to_f
    end
    
    def units
      self.class.unit
    end
    
    def u
      self.class.unit_abbreviation
    end
    
    def method_missing(*args)
      if Conversions.conversions[units.to_sym][args.first]
        to_f.send(units.to_sym).to(args.first)
      else
        super
      end
    end
    
    class << self
      def units(units)
        @units, @units_abbreviation = units.to_a.flatten
      end
      
      def unit
        @units
      end
      
      def unit_abbreviation
        @units_abbreviation
      end
    end
  end
end
