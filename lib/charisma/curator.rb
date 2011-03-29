module Charisma
  class Curator
    attr_reader :subject
    
    def initialize(subject)
      @subject = subject
    end
        
    def [](key)
      if value = subject.send(key)
        Curation.new value, subject.class.characterization[key]
      end
    end
        
    def keys
      subject.class.characterization.keys.select do |key|
        !!subject.send(key)
      end
    end

    def slice(*only_keys)
      only_keys.inject({}) do |memo, key|
        if curation = self[key]
          memo[key] = curation
        end
        memo
      end
    end
    
    def to_hash
      subject.class.characterization.keys.inject({}) do |memo, key|
        if curation = self[key]
          memo[key] = curation
        end
        memo        
      end
    end
  end
end
