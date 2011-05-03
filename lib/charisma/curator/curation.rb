module Charisma
  module Curator
    module Curation
      attr_reader :value, :characteristic
      
      def init(characteristic = nil)
        @characteristic = characteristic
        self
      end
      
      delegate :to_s, :units, :u, :to => :render
      
      private
      
      def render
        return self unless characteristic
        return characteristic if characteristic.is_a? Fixnum
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
        characteristic.proc.call(self)
      end
      
      def use_accessor
        send(characteristic.accessor)
      end
      
      def defer_to_measurement
        case characteristic.measurement
        when Class
          characteristic.measurement.new(self)
        when Symbol
          "Charisma::Measurement::#{characteristic.measurement.to_s.camelize}".constantize.new(self)
        else
          raise InvalidMeasurementError
        end
      end
      
      def defer_to_value
        as_characteristic
      end
      
      def render_value
        self
      end
      
      class Proxy
        include Curation
        def initialize(value)
          @characteristic = value
        end
      end
    end
  end
end
