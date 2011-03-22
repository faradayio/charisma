module Charisma
  module Base
    module ClassMethods
      def self.extended(base)
        base.send :class_variable_set, :@@characterization, Characterization.new
        base.send :cattr_reader, :characterization
      end
      def characterize(&blk)
        Blockenspiel.invoke(blk, characterization) if block_given?
      end
    end
  end
end

