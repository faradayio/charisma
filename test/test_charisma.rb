require File.expand_path('helper', File.dirname(__FILE__))

require 'support/planet'
require 'support/spaceship'
require 'support/spaceship_fuel'
require 'support/spaceship_make'

class TestCharisma < Test::Unit::TestCase
  def test_001_simple_attribute_characteristic
    spaceship = Spaceship.new :name => 'Amaroq'
    assert_equal 'Amaroq', spaceship.characteristics[:name].to_s
  end
  
  def test_002_measured_attribute
    spaceship = Spaceship.new :size => 10 # metres
    assert_equal '10 m', spaceship.characteristics[:size].to_s
  end
  
  def test_003_classified_attribute
    spaceship = Spaceship.new :weight => 1_000_000 # hg
    assert_equal '1,000,000 hg', spaceship.characteristics[:weight].to_s
  end
  
  def test_004_units
    spaceship = Spaceship.new :weight => '1000000.1' # kg
    assert_equal :hollagrams, spaceship.characteristics[:weight].units
    assert_equal 'hg', spaceship.characteristics[:weight].u
    assert_equal 2_000_000.2, spaceship.characteristics[:weight].supertons
  end
  
  def test_005_attribute_with_custom_display
    spaceship = Spaceship.new :window_count => 10
    assert_equal '10 windows', spaceship.characteristics[:window_count].to_s
  end
  
  def test_006_simple_association
    planet = Planet.create :name => 'Pluto'
    spaceship = Spaceship.new :destination => planet
    assert_equal 'Pluto', spaceship.characteristics[:destination].to_s
  end
  
  def test_007_association_with_display_hint
    make = SpaceshipMake.create :name => 'Boeing'
    spaceship = Spaceship.new :make => make
    assert_equal 'Boeing', spaceship.characteristics[:make].to_s
  end
  
  def test_008_association_with_prepared_display
    fuel = SpaceshipFuel.create :name => 'Kerosene', :emission_factor => 10
    spaceship = Spaceship.new :fuel => fuel
    assert_equal 'Kerosene (10 kg CO2/L)', spaceship.characteristics[:fuel].to_s
  end
  
  def test_009_number_helper
    assert_equal '1,000', Charisma::NumberHelper.delimit(1_000)
  end
  
  def test_010_characteristics_slice
    spaceship = Spaceship.new :name => 'Amaroq', :window_count => 2, :size => 10
    assert_equal '10 m', spaceship.characteristics.slice(:size, :window_count)[:size].to_s
    assert_equal nil, spaceship.characteristics.slice(:size, :window_count)[:name]
    assert_equal 2, spaceship.characteristics.slice(:size, :window_count).values.length
  end
  
  def test_011_associated_object_methods
    planet = Planet.create :name => 'Pluto'
    spaceship = Spaceship.new :destination => planet
    assert_equal BigDecimal('1.31e+1_022'), spaceship.characteristics[:destination].mass
  end
  
  def test_011_characteristic_arithmetic
    amaroq = Spaceship.new :window_count => 8
    geo = Spaceship.new :window_count => 6
    assert_equal 2, amaroq.characteristics[:window_count] - geo.characteristics[:window_count]
  end
  
  def test_012_missing_characteristics_can_still_be_accessed
    spaceship = Spaceship.new :name => 'Amaroq'
    assert_equal Charisma::Curator::Curation, spaceship.characteristics[:size].class
    assert_equal nil, spaceship.characteristics[:size].value
  end
  
  def test_013_characteristics_keys
    spaceship = Spaceship.new :name => 'Amaroq'
    assert_equal [:name].sort_by { |k| k.to_s }, spaceship.characteristics.keys.sort_by { |k| k.to_s }
  end
  
  def test_014_characterization_keys
    assert_equal [:color, :destination, :fuel, :make, :name, :size, :weight, :window_count].sort_by { |k| k.to_s }, Spaceship.characterization.keys.sort_by { |k| k.to_s }
  end
  
  def test_015_characteristic_equality
    amaroq = Spaceship.new :window_count => 8
    buster = Spaceship.new :window_count => 8
    assert_equal amaroq.characteristics, buster.characteristics
  end
  
  def test_016_inspection_of_undefined_characteristic
    muktruk = Spaceship.new
    muktruk.characteristics[:bumper_sticker] = 'LT'
    assert_nothing_raised do
      muktruk.characteristics[:bumper_sticker].inspect
    end
  end
  
  def test_017_each
    spaceship = Spaceship.new :name => 'Amaroq'
    catch :blam do
      spaceship.characteristics.each do |k, v|
        throw :blam if k == :name
      end
      flunk
    end
  end
  
  def test_018_double_bag
    geo = SpaceshipMake.create :name => 'Geo'
    g = Spaceship.new :make => geo
    g.characteristics[:name] = g.characteristics[:make]
    assert_equal 'Geo', g.characteristics[:name].to_s
  end
  
  def test_019_compare_fixnum
    amaroq = Spaceship.new :window_count => 8
    assert(amaroq.characteristics == { :window_count => 8 })
  end
  
  def test_020_to_hash
    spaceship = Spaceship.new :name => 'Amaroq', :window_count => 2, :size => 10
    assert_equal({:name => 'Amaroq', :window_count => 2, :size => 10}, spaceship.characteristics.to_hash)
  end
  
  def test_021_dup
    spaceship = Spaceship.new :name => 'Amaroq'
    initial_characteristics = spaceship.characteristics.dup
    assert_equal [:name], initial_characteristics.keys
    spaceship.characteristics[:window_count] = 2
    assert_equal [:name], initial_characteristics.keys
    assert_equal [:name, :window_count], spaceship.characteristics.keys
  end
  
  def test_022_nil_units
    spaceship = Spaceship.new
    assert_equal nil, spaceship.characteristics[:name].units
    assert_equal :hollagrams, spaceship.characteristics[:weight].units
  end
  
  def test_023_json
    planet = Planet.create :name => 'Pluto'
    spaceship = Spaceship.new :weight => 100, :window_count => 3, :destination => planet
    assert_equal({:value => 100, :units => 'hollagrams'}, spaceship.characteristics[:weight].as_json)
    assert_equal 3, spaceship.characteristics[:window_count].as_json
    assert_equal({:name => 'Pluto'}, spaceship.characteristics[:destination].as_json)
  end

  def test_024_equality_and_hash
    # should be different
    lite = Spaceship.new :weight => 1
    heavy = Spaceship.new :weight => 999
    assert(lite != heavy)
    assert(lite.characteristics.hash != heavy.characteristics.hash)

    lite_weight = lite.characteristics[:weight]
    heavy_weight = heavy.characteristics[:weight]
    assert(lite_weight != heavy_weight)
    assert(lite_weight.hash != heavy_weight.hash)

    lite_slice = lite.characteristics.slice(:weight)
    heavy_slice = heavy.characteristics.slice(:weight)
    assert(lite_slice != heavy_slice)
    assert(lite_slice.hash != heavy_slice.hash)

    # should be the same
    lite1 = Spaceship.new :weight => 1
    lite2 = Spaceship.new :weight => 1
    assert_equal lite1, lite2
    assert_equal lite1.characteristics.hash, lite2.characteristics.hash

    lite1_weight = lite1.characteristics[:weight]
    lite2_weight = lite2.characteristics[:weight]
    assert_equal lite1_weight, lite2_weight
    assert_equal lite1_weight.hash, lite2_weight.hash

    lite1_slice = lite1.characteristics.slice(:weight)
    lite2_slice = lite2.characteristics.slice(:weight)
    assert_equal lite1_slice, lite2_slice
    assert_equal lite1_slice.hash, lite2_slice.hash
  end
end
