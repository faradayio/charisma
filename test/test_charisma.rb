require 'helper'

class TestCharisma < Test::Unit::TestCase
  def test_simple_attribute_characteristic
    spaceship = Spaceship.new :name => 'Amaroq'
    assert_equal 'Amaroq', spaceship.characteristics[:name]
  end
  def test_measured_attribute
    spaceship = Spaceship.new :size => 10 # meters
    assert_equal '10 m', spaceship.characteristics[:size].to_s
  end
  def test_classified_attribute
    spaceship = Spaceship.new :weight => 1_000_000 # kg
    assert_equal '1,000,000 kg', spaceship.characteristics[:weight].to_s
  end
  def test_units
    spaceship = Spaceship.new :weight => '1000000.1' # kg
    assert_equal :kilograms, spaceship.characteristics[:weight].units
    assert_equal 'kg', spaceship.characteristics[:weight].u
    assert_equal 1_102, spaceship.characteristics[:weight].tons.round
  end
  def test_attribute_with_custom_display
    spaceship = Spaceship.new :window_count => 10
    assert_equal '10 windows', spaceship.characteristics[:window_count].to_s
  end
  def test_simple_association
    planet = Planet.new :name => 'Pluto'
    spaceship = Spaceship.new :destination => pluto
    assert_equal 'Pluto', spaceship.characteristics[:destination].to_s
  end
  def test_association_with_display_hint
    make = SpaceshipMake.new :name => 'Boeing'
    spaceship = Spaceship.new :make => make
    assert_equal 'Boeing', spaceship.characteristics[:make].to_s
  end
  def test_association_with_prepared_display
    fuel = SpaceshipFuel.new :name => 'Kerosene', :emission_factor => 10
    spaceship = Spaceship.new :fuel => fuel
    assert_equal 'Kerosene (10 kg CO2/L)', spaceship.characteristics[:fuel].to_s
  end
end
