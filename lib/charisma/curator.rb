require 'forwardable'
module Charisma
  # A Hash-like object that stores computed characteristics about an instance of a characterized class.
  #
  # Every instance of a characterized class gets a Curator, accessed via <tt>#characteristics</tt>.
  # @see Charisma::Base#characteristics
  class Curator
    # The curator's subject--the instance itself' 
    attr_reader :subject
    
    # The hashed wrapped by the curator that actually stores the computed characteristics'
    attr_reader :characteristics
    
    # Create a Curator.
    #
    # Typically this is done automatically when <tt>#characteristics</tt> is called on an instance of a characterized class for the first time.
    # @param [Object] The subject of the curation -- an instance of a characterized class
    # @see Charisma::Base#characteristics
    def initialize(subject)
      @characteristics = {}.extend LooseEquality
      @subject = subject
      subject.class.characterization.keys.each do |key|
        if subject.respond_to?(key) and value = subject.send(key)
          self[key] = value
        end
      end
    end
    
    # Store a late-defined characteristic, with a Charisma wrapper.
    # @param [Symbol] key The name of the characteristic, which must match one defined in the class's characterization
    # @param value The value of the characteristic
    def []=(key, value)
      characteristics[key] = Curation.new value, subject.class.characterization[key]
    end
    
    # A custom inspection method to enhance IRB and log readability
    def inspect
      "<Charisma:Curator #{keys.length} known characteristic(s)>"
    end
    
    # (see #inpsect)
    def to_s; inspect end
    
    extend Forwardable
    delegate [:[], :keys, :slice, :==, :each] => :characteristics
    
    # Loose equality for Hashlike objects
    #
    # <tt>Hash#==</tt> as defined in Ruby core is very, very strict: it uses <tt>Object#==</tt> on each of its values to determine equality.
    # This module overrides <tt>#==</tt> to loosen this evaluation.
    module LooseEquality
      # Determine equality with another Hashlike object, loosely.
      #
      # Unlike Ruby's own <tt>Hash#==</tt>, this method uses the values' native <tt>#==</tt> methods, where available, to determine equality.
      # @param [Hash] other The other hash
      def ==(other)
        return false unless keys.sort == other.keys.sort
        keys.all? do |k|
          self[k] == other[k]
        end
      end
    end
  end
end
