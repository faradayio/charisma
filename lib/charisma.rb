module Charisma
  def self.included(base)
    base.extend ClassMethods
  end
  module ClassMethods
    def characterize; end
  end
  class Measurement
    def self.units(*); end
  end
end
