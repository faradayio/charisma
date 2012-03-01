module Charisma
  # An abstract class that implements an API for Charisma to deal with measured characteristics.
  #
  # @abstract An actual measurement class should inherit from this and use <tt>#units</tt> to define units.
  class Measurement
    
    # The quantity of the measured value
    attr_reader :value
    
    # Create a new instance of this measurement.
    #
    # Typically this will be done automatically by <tt>Charisma::Curator::Curation</tt>.
    # @param [Fixnum] value The quantity of the measured value
    # @see Charisma::Curator::Curation
    def initialize(value)
      @value = value
    end

    # Show the measured value, along with units
    # @return [String]
    def to_s
      "#{NumberHelper.delimit value} #{u}"
    end
    
    # Return just the quantity of the measurement
    # @return [Fixnum]
    def to_f
      value.to_f
    end
    
    # The measurement's units
    # @return [Symbol]'
    def units
      self.class.unit
    end
    
    # The standard abbreviation for the measurement's units
    # @return [String]
    def u
      self.class.unit_abbreviation
    end
    
    # Handle conversion methods
    def method_missing(*args)
      if Conversions.conversions[units.to_sym][args.first]
        to_f.send(units.to_sym).to(args.first)
      else
        super
      end
    end

    # Provide a hash form
    def to_hash
      { :value => value, :units => units.to_s }
    end

    # Provide a hash for later conversion to JSON
    def as_json
      to_hash
    end
    
    class << self
      # Define the units used with this measurement.
      #
      # Used by conforming subclasses.
      # @param [Hash] units The units, given in the form <tt>:plural_unit_name => 'abbrev'</tt>
      def units(units)
        @units, @units_abbreviation = units.to_a.flatten
      end
      
      # Retrive the units used by the measurement
      # @return [Symbol]
      def unit
        @units
      end
      
      # Retrieve the abbreviation of the units used by the measurement
      # @return [String]
      def unit_abbreviation
        @units_abbreviation
      end
    end
  end
end
