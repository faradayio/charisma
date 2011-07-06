module Charisma
  # Stores information about a characteristic.
  #
  # Typically these are defined with <tt>Charisma::Characterization#has</tt> in a <tt>characterize do . . . end</tt> block.
  # @see Charisma::Base::ClassMethods#characterize
  # @see Charisma::Characterization#has
  class Characteristic
    # The characteristic's name
    attr_reader :name
    
    # A proc, if defined, that specifies how the characteristic should be displayed
    attr_reader :proc
    
    # A method that should be called on the characteristic in order to display it properly
    attr_reader :accessor
    
    # Specifies that the characteristic should be treated as a measured quantity
    attr_reader :measurement
    
    # Create a characteristic.
    #
    # Typically this is done via <tt>Charisma::Characterization#has</tt> within a <tt>characterize do . . . end</tt> block.
    # @param [Symbol] name The name of the characteristic. The method with this name will be called on the characterized object to retrieve its raw value.
    # @param [Hash] options The options hash.
    # @option [Symbol] display_with A symbol that gets sent as a method on the characteristic to retrieve its display value.
    # @option [Class, Symbol] measures Specifies a measurement for the characteristic. Either provide a class constant that conforms to the Charisma::Measurement API, or use a symbol to specify a built-in Charisma measurement.
    # @option [Proc] blk A proc that defines how the characteristic should be displayed.
    # @see Charisma::Base::ClassMethods#characterize
    # @see Charisma::Characterization#has
    # @see Charisma::Measurement
    def initialize(name, options, &blk)
      @name = name
      @proc = blk if block_given?
      @accessor = options[:display_with]
      @measurement = options[:measures]
    end
    
    # The subclass of <tt>Charisma::Measurement</tt> with which this curation's characteristic is measured.
    # @return [Class]
    def measurement_class
      case measurement
      when ::Class
        measurement
      when ::Symbol
        "::Charisma::Measurement::#{measurement.to_s.camelize}".constantize
      else
        raise InvalidMeasurementError
      end
    end
  end
end
