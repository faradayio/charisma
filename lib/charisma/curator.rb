module Charisma
  class Curator
    def initialize(base)
      @subject = base
    end
    
    def [](name)
      Curation.new @subject.send(name), @subject.class.characterization[name]
    end
    
    def keys
      @subject.class.characterization.keys
    end
  end
end
