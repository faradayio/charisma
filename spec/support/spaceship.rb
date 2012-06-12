require 'supermodel'
require File.expand_path('relative_astronomic_mass', File.dirname(__FILE__))

class Spaceship < SuperModel::Base
  attributes :window_count, :name, :size, :weight
  belongs_to :make, :class_name => 'SpaceshipMake', :primary_key => 'name'
  belongs_to :fuel, :class_name => 'SpaceshipFuel', :primary_key => 'name'
  belongs_to :destination, :class_name => 'Planet', :primary_key => 'name'
  
  def ==(other)
    attributes == other.attributes
  end

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
