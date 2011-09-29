require 'supermodel'

class SpaceshipFuel < SuperModel::Base
  has_many :spaceships
  attributes :name, :emission_factor
  self.primary_key = :name 
  
  def as_characteristic
    "#{name} (#{emission_factor} kg CO2/L)"
  end
end
