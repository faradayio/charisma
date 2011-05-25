require 'bigdecimal'
require 'rubygems'
require 'test/unit'
require 'supermodel'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'charisma'

class Test::Unit::TestCase
end

class RelativeAstronomicMass < Charisma::Measurement # or don't inherit and provide everything yourself
  units :hollagrams => 'hg' 
  # before_ and after_ filters or some other reason to use this as opposed to Charisma::Measurements::Mass
end

class Spaceship < SuperModel::Base
  attributes :window_count, :name, :size, :weight
  belongs_to :make, :class_name => 'SpaceshipMake', :primary_key => 'name'
  belongs_to :fuel, :class_name => 'SpaceshipFuel', :primary_key => 'name'
  belongs_to :destination, :class_name => 'Planet', :primary_key => 'name'
  
  include Charisma
  characterize do
    has :make, :display_with => :name
    has :fuel
    has :window_count do |window_count|
      "#{window_count} windows"
    end
  end
  
  characterize do
    has :size, :measures => :length # uses Charisma::Measurements::Length
    has :weight, :measures => RelativeAstronomicMass
    has :name
    has :destination
    has :color
  end
end

class SpaceshipMake < SuperModel::Base
  has_many :spaceships
  attributes :name
  self.primary_key = :name 
end

class SpaceshipFuel < SuperModel::Base
  has_many :spaceships
  attributes :name, :emission_factor
  self.primary_key = :name 
  
  def as_characteristic
    "#{name} (#{emission_factor} kg CO2/L)"
  end
end

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

Conversions.register :hollagrams, :supertons, 2
