module Charisma
  class Curator
    def initialize(subject)
      @subject = subject
    end
        
    def [](name)
      Curation.new @subject.send(name), @subject.class.characterization[name]
    end
    
    def keys
      @subject.class.characterization.keys
    end

    def slice(*k)
      k.inject({}) { |memo, k| memo[k] = self[k]; memo }
    end
  end
end
