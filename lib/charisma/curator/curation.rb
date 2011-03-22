module Charisma
  class Curator
    class Curation
      attr_reader :value, :characteristic
      
      def initialize(value, characteristic)
        @value = value
        @characteristic = characteristic
      end
      
      delegate :to_s, :units, :u, :to => :render
      
      def method_missing(*args)
        begin
          render.send(*args)
        rescue NoMethodError
          super
        end
      end
      
      private
      
      def render
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
        case characteristic.measurement
        when Class
          characteristic.measurement.new(value)
        when Symbol
          "Charisma::Measurement::#{characteristic.measurement.to_s.camelize}".constantize.new(value)
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
