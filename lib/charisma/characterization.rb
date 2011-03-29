module Charisma
  class Characterization < Hash    
    include Blockenspiel::DSL
    def has(name, options = {}, &blk)
      name = name.to_sym
      self[name] = Characteristic.new(name, options, &blk)
    end
  end
end
