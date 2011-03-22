module Charisma
  class Characterization
    attr_reader :characteristics
    
    def initialize
      @characteristics = {}
    end
    
    def [](name)
      characteristics[name]
    end
    
    include Blockenspiel::DSL
    def has(name, options = {}, &blk)
      name = name.to_sym
      characteristics[name] = Characteristic.new(name, options, &blk)
    end
  end
end
