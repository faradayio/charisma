module Charisma
  module Base
    # Methods included on the characterized class
    module ClassMethods
      # Establishes a <tt>@@characterization</tt> class variable along with a <tt>#characterization</tt> accessor on the class.
      #
      # @see Charisma::Characterizaion
      def self.extended(base)
        base.send :class_variable_set, :@@characterization, Characterization.new
        base.send :cattr_reader, :characterization, :instance_reader => false
      end
      
      # Define a characterization on the class.
      #
      # The definition occurs within the block, using <tt>Charisma::Characterization#has</tt> as a DSL.
      # @see Charisma::Characterization#has
      def characterize(&blk)
        if block_given?
          characterization.instance_eval(&blk)
        end
      end
    end
  end
end

