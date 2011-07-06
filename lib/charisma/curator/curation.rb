require 'delegate'
module Charisma
  class Curator
    # A wrapper around computed characteristic values that intervenes when the value is asked to present itself.
    #
    # Implements the Delegator pattern, with uncaught methods delegated to the characteristic's computed value.
    # (Undocumented below is that <tt>#to_s</tt> is specifically delegated to <tt>#render</tt>.)
    class Curation < ::Delegator
      extend ::Forwardable
      
      # The computed value of the characteristic
      attr_accessor :value
      
      # The characteristic, as defined in the class's characterization
      # @return [Charisma::Characteristic]
      attr_reader :characteristic
      
      # Create new Curation wrapper.
      #
      # This is typically done by the instance's <tt>Charisma::Curator</tt>
      # @param value The computed value of the characteristic for the instance
      # @param [Charisma::Characteristic, optional] characteristic The associated characteristic definition
      def initialize(value, characteristic = nil)
        @characteristic = characteristic
        establish_units_methods if characteristic && characteristic.measurement
        self.value = value
      end
      
      def_delegators :render, :to_s

      def ==(other)
        a = self.value
        b = other.respond_to?(:value) ? other.value : other
        a == b
      end

      # An inspection method for more readable IRB sessions and logs.
      def inspect
        if characteristic
          "<Charisma::Curator::Curation for :#{characteristic.name} (use #to_s to render value of #{value.class})>"
        else
          "<Charisma::Curator::Curation for undefined characteristic (use #to_s to render value of #{value.class})>"
        end          
      end
      
      # Delegator method
      def __getobj__; value end

      # Delegator method
      def __setobj__(obj); self.value = obj end
      
      private
      
      # If this curation deals with a measured characteristic, this method will delegate <tt>#u</tt>, <tt>#units</tt>, and appropriate unit-name methods to <tt>#render</tt>.
      def establish_units_methods
        self.class.def_delegators :render, :u, :units
        if conversions = Conversions.conversions[units.to_sym]
          self.class.def_delegators :render, *conversions.keys
        end
      end
      
      # Provide a display-friendly presentation of the computed characteristic's value.
      # @return [String]
      def render
        return value unless characteristic
        if characteristic.proc
          render_proc
        elsif characteristic.accessor
          use_accessor
        elsif characteristic.measurement
          defer_to_measurement
        elsif value.respond_to? :as_characteristic
          defer_to_value
        else
          render_value
        end
      end
      
      # Render the value using the characteristic's proc.
      def render_proc
        characteristic.proc.call(value)
      end
      
      # Render the value using an accessor on the characteristic's association.
      def use_accessor
        value.send(characteristic.accessor)
      end
      
      # Render the value using its specified measurement.
      def defer_to_measurement
        characteristic.measurement_class.new(value)
      end
      
      # Render the value using its <tt>#as_characteristic</tt> method.
      def defer_to_value
        value.as_characteristic
      end
      
      # Render the value using its <tt>#to_s</tt> method.
      def render_value
        value
      end
    end
  end
end
