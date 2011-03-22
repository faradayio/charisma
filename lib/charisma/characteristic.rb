module Charisma
  class Characteristic
    attr_reader :name, :proc, :accessor, :measurement
    
    def initialize(name, options, &blk)
      @name = name
      @proc = blk if block_given?
      @accessor = options[:display_method]
      @measurement = options[:measures]
    end
  end
end
