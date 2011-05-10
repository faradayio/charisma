require 'delegate'
module Charisma
  class Curator
    class Curation < Delegator
      extend Forwardable
      attr_accessor :value
      attr_reader :characteristic
      
      def initialize(value, characteristic = nil)
        @characteristic = characteristic
        establish_units_methods if characteristic && characteristic.measurement
        self.value = value
      end
      
      delegate [:to_s] => :render

      def inspect
        "<Charisma::Curator::Curation for :#{characteristic.name} (use #to_s to render value of #{value.class})>"
      end
      
      # Delegator methods
      def __getobj__; value end
      def __setobj__(obj); self.value = obj end
      
      private
      
      def establish_units_methods
        self.class.delegate [:u, :units] => :render
        if conversions = Conversions.conversions[units.to_sym]
          self.class.delegate conversions.keys => :render
        end
      end
      
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
      
      def render_proc
        characteristic.proc.call(value)
      end
      
      def use_accessor
        value.send(characteristic.accessor)
      end
      
      def defer_to_measurement
        measurement_class.new(value)
      end
      
      def measurement_class
        case characteristic.measurement
        when Class
          characteristic.measurement
        when Symbol
          "Charisma::Measurement::#{characteristic.measurement.to_s.camelize}".constantize
        else
          raise InvalidMeasurementError
        end
      end
      
      def defer_to_value
        value.as_characteristic
      end
      
      def render_value
        value
      end
    end
  end
end
