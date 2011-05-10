require 'forwardable'
module Charisma
  class Curator
    attr_reader :subject, :characteristics
    
    def initialize(subject)
      @characteristics = {}.extend LooseEquality
      @subject = subject
      subject.class.characterization.keys.each do |key|
        if value = subject.send(key)
          self[key] = value
        end
      end
    end
    
    def []=(key, value)
      characteristics[key] = Curation.new value, subject.class.characterization[key]
    end
    
    def inspect
      "<Charisma:Curator #{keys.length} known characteristic(s)>"
    end
    
    def to_s; inspect end
    
    extend Forwardable
    delegate [:[], :keys, :slice, :==] => :characteristics
    
    module LooseEquality
      def ==(other)
        return false unless keys.sort == other.keys.sort
        keys.all? do |k|
          self[k] == other[k]
        end
      end
    end
  end
end
