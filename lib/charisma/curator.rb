module Charisma
  module Curator
    def subject; @subject end
    
    def init(subject)
      @subject = subject
      subject.characterization.keys.each do |key|
        if value = subject.send(key)
          self[key] = value
        end
      end
      self
    end
    
    def []=(key, value)
      super key, curate(key, value)
    end
    
    private
    
    def curate(key, value)
      case value
      when Fixnum #, TrueClass, NilClass, FalseClass
        value.instance_variable_set :@charisma, [subject, subject.class.characterization[key]]
      else
        value.extend(Curation).init(subject.class.characterization[key])
      end
    end
  end
end
