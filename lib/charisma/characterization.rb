module Charisma
  # Stores the set of characteristics defined on a class.
  #
  # Typically this is created with <tt>Charisma::Base::ClassMethods#characterize</tt>, and characteristics defined within it by the ensuing block.
  class Characterization < Hash
    # Define a characteristic.
    #
    # This is used within <tt>Charisma::Base::ClassMethods#characterize</tt> blocks to curate attributes on a class. Internally, a <tt>Charisma::Characteristic</tt> is created to store the definition.
    # @param [Symbol] 
    # @param [Symbol] name The name of the characteristic. The method with this name will be called on the characterized object to retrieve its raw value.
    # @param [Hash] options The options hash.
    # @option [Symbol] display_with A symbol that gets sent as a method on the characteristic to retrieve its display value.
    # @option [Class, Symbol] measures Specifies a measurement for the characteristic. Either provide a class constant that conforms to the Charisma::Measurement API, or use a symbol to specify a built-in Charisma measurement.
    # @option [Proc] blk A proc that defines how the characteristic should be displayed.
    # @see Charisma::Base::ClassMethods#characterize
    # @see Charisma::Characteristic
    # @see Charisma::Measurement
    def has(name, options = {}, &blk)
      name = name.to_sym
      self[name] = Characteristic.new(name, options, &blk)
    end
  end
end
