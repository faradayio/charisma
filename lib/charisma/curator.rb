require 'forwardable'
module Charisma
  class Curator
    attr_reader :subject, :characteristics
    
    def initialize(subject)
      @characteristics = {}
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
    delegate [:[], :keys, :slice] => :characteristics 
  end
end
