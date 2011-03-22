require 'rubygems'
require 'test/unit'
require 'supermodel'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'charisma'

class Test::Unit::TestCase
end

class RelativeAstronomicMass < Charisma::Measurement # or don't inherit and provide everything yourself
  units :kilograms
  # before_ and after_ filters or some other reason to use this as opposed to Charisma::Measurements::Mass
end

class Spaceship < SuperModel::Base
  attributes :window_count, :name, :size
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
    has :size, :measures => :length # uses Charisma::Measurements::Length
    has :weight, :measures => RelativeAstronomicMass
    has :name
    has :destination
  end
end

class SpaceshipMake < SuperModel::Base
  has_many :spaceships
  attributes :name
end

class SpaceshipFuel < SuperModel::Base
  has_many :spaceships
  attributes :name, :emission_factor
  
  def as_characteristic
    "#{name} (#{emission_factor} kg CO2/L)"
  end
end

class Planet < SuperModel::Base
  has_many :spaceships
  attributes :name
  
  def to_s
    name
  end
end
