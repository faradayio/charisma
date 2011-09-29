require 'supermodel'

class Planet < SuperModel::Base
  has_many :spaceships
  attributes :name
  self.primary_key = :name 
  
  def to_s
    name
  end
  
  def mass
    case name
    when 'Pluto'
      BigDecimal('1.31e+1_022')
    else
      raise "unknown"
    end
  end
end
