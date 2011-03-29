module Charisma
  class Curator
    def initialize(subject)
      @subject = subject
    end
        
    def [](key)
      if value = @subject.send(key)
        Curation.new value, @subject.class.characterization[key]
      end
    end
    
    def keys
      @subject.class.characterization.keys.select do |key|
        !!@subject.send(key)
      end
    end

    def slice(*keys)
      keys.inject({}) do |memo, key|
        if curation = self[key]
          memo[key] = curation
        end
        memo
      end
    end
  end
end
