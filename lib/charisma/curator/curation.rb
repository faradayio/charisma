module Charisma
  class Curator
    class Curation
      attr_reader :value, :characteristic
      
      def initialize(value, characteristic)
        @value = value
        @characteristic = characteristic
      end
      
      def to_s
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
      
      private
      
      def render_proc
        characteristic.proc.call(value).to_s
      end
      
      def use_accessor
        value.send(characteristic.accessor).to_s
      end
      
      def defer_to_measurement
        case characteristic.measurement
        when Class
          value.extend(characteristic.measurement).to_s
        when Symbol
          value.extend("Charisma::Measurements::#{characteristic.measurement.to_s.camelize}".constantize).to_s
        else
          raise InvalidMeasurementError
        end
      end
      
      def defer_to_value
        value.as_characteristic.to_s
      end
      
      def render_value
        value.to_s
      end
    end
  end
end
