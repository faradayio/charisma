require 'helper'

describe Charisma do
  it "simple_attribute_characteristic" do
    spaceship = Spaceship.new :name => 'Amaroq'
    spaceship.characteristics[:name].to_s.must_equal 'Amaroq'
  end
  
  it "measured_attribute" do
    spaceship = Spaceship.new :size => 10 # metres
    spaceship.characteristics[:size].to_s.must_equal '10 m'
  end
  
  it "classified_attribute" do
    spaceship = Spaceship.new :weight => 1_000_000 # hg
    spaceship.characteristics[:weight].to_s.must_equal '1,000,000 hg'
  end
  
  it "units" do
    spaceship = Spaceship.new :weight => '1000000.1' # kg
    spaceship.characteristics[:weight].units.must_equal :hollagrams
    spaceship.characteristics[:weight].u.must_equal 'hg'
    assert_in_delta spaceship.characteristics[:weight].supertons.to_f, 200_000.02, 0.01
  end
  
  it "attribute_with_custom_display" do
    spaceship = Spaceship.new :window_count => 10
    spaceship.characteristics[:window_count].to_s.must_equal '10 windows'
  end
  
  it "simple_association" do
    planet = Planet.create :name => 'Pluto'
    spaceship = Spaceship.new :destination => planet
    spaceship.characteristics[:destination].to_s.must_equal 'Pluto'
  end
  
  it "association_with_display_hint" do
    make = SpaceshipMake.create :name => 'Boeing'
    spaceship = Spaceship.new :make => make
    spaceship.characteristics[:make].to_s.must_equal 'Boeing'
  end
  
  it "association_with_prepared_display" do
    fuel = SpaceshipFuel.create :name => 'Kerosene', :emission_factor => 10
    spaceship = Spaceship.new :fuel => fuel
    spaceship.characteristics[:fuel].to_s.must_equal 'Kerosene (10 kg CO2/L)'
  end
  
  it "number_helper" do
    Charisma::NumberHelper.delimit(1_000).must_equal '1,000'
  end
  
  it "characteristics_slice" do
    spaceship = Spaceship.new :name => 'Amaroq', :window_count => 2, :size => 10
    spaceship.characteristics.slice(:size, :window_count)[:size].to_s.must_equal '10 m'
    spaceship.characteristics.slice(:size, :window_count)[:name].must_equal nil
    spaceship.characteristics.slice(:size, :window_count).values.length.must_equal 2
  end
  
  it "associated_object_methods" do
    planet = Planet.create :name => 'Pluto'
    spaceship = Spaceship.new :destination => planet
    spaceship.characteristics[:destination].mass.must_equal BigDecimal('1.31e+1_022')
  end
  
  it "characteristic_arithmetic" do
    amaroq = Spaceship.new :window_count => 8
    geo = Spaceship.new :window_count => 6
    (amaroq.characteristics[:window_count] - geo.characteristics[:window_count]).must_equal 2
  end
  
  it "missing_characteristics_can_still_be_accessed" do
    spaceship = Spaceship.new :name => 'Amaroq'
    spaceship.characteristics[:size].class.must_equal Charisma::Curator::Curation
    spaceship.characteristics[:size].value.must_equal nil
  end
  
  it "characteristics_keys" do
    spaceship = Spaceship.new :name => 'Amaroq'
    spaceship.characteristics.keys.sort_by { |k| k.to_s }.must_equal [:name]
  end
  
  it "characterization_keys" do
    Spaceship.characterization.keys.sort_by { |k| k.to_s }.must_equal([:color, :destination, :fuel, :make, :name, :size, :weight, :window_count].sort_by { |k| k.to_s })
  end
  
  it "characteristic_equality" do
    amaroq = Spaceship.new :window_count => 8
    buster = Spaceship.new :window_count => 8
    buster.characteristics.must_equal amaroq.characteristics
  end
  
  it "inspection_of_undefined_characteristic" do
    muktruk = Spaceship.new
    muktruk.characteristics[:bumper_sticker] = 'LT'
    muktruk.characteristics[:bumper_sticker].inspect.must_include 'undefined characteristic'
  end
  
  it "each" do
    spaceship = Spaceship.new :name => 'Amaroq'
    catch :blam do
      spaceship.characteristics.each do |k, v|
        throw :blam if k == :name
      end
      flunk
    end
  end
  
  it "double_bag" do
    geo = SpaceshipMake.create :name => 'Geo'
    g = Spaceship.new :make => geo
    g.characteristics[:name] = g.characteristics[:make]
    g.characteristics[:name].to_s.must_equal 'Geo'
  end
  
  it "compare_fixnum" do
    amaroq = Spaceship.new :window_count => 8
    amaroq.characteristics.must_equal({ :window_count => 8 })
  end
  
  it "to_hash" do
    spaceship = Spaceship.new :name => 'Amaroq', :window_count => 2, :size => 10
    spaceship.characteristics.to_hash.must_equal({:name => 'Amaroq', :window_count => 2, :size => 10})
  end
  
  it "dup" do
    spaceship = Spaceship.new :name => 'Amaroq'
    initial_characteristics = spaceship.characteristics.dup
    initial_characteristics.keys.must_equal [:name]
    spaceship.characteristics[:window_count] = 2
    initial_characteristics.keys.must_equal [:name]
    spaceship.characteristics.keys.sort_by { |k| k.to_s }.must_equal [:name, :window_count]
  end
  
  it "nil_units" do
    spaceship = Spaceship.new
    spaceship.characteristics[:name].units.must_equal nil
    spaceship.characteristics[:weight].units.must_equal :hollagrams
  end
  
  it "json" do
    planet = Planet.create :name => 'Pluto'
    spaceship = Spaceship.new :weight => 100, :window_count => 3, :destination => planet
    spaceship.characteristics[:weight].as_json.must_equal({:value => 100, :units => 'hollagrams'})
    spaceship.characteristics[:window_count].as_json.must_equal 3
    spaceship.characteristics[:destination].as_json.must_equal({:name => 'Pluto'})
  end

  it "equality_and_hash" do
    # should be different
    lite = Spaceship.new :weight => 1
    heavy = Spaceship.new :weight => 999
    heavy.wont_equal lite
    heavy.characteristics.hash.wont_equal lite.characteristics.hash

    lite_weight = lite.characteristics[:weight]
    heavy_weight = heavy.characteristics[:weight]
    heavy_weight.wont_equal lite_weight
    heavy_weight.hash.wont_equal lite_weight.hash

    lite_slice = lite.characteristics.slice(:weight)
    heavy_slice = heavy.characteristics.slice(:weight)
    heavy_slice.wont_equal lite_slice
    heavy_slice.hash.wont_equal lite_slice.hash

    # should be the same
    lite1 = Spaceship.new :weight => 1
    lite2 = Spaceship.new :weight => 1
    lite2.must_equal lite1
    lite2.characteristics.hash.must_equal lite1.characteristics.hash

    lite1_weight = lite1.characteristics[:weight]
    lite2_weight = lite2.characteristics[:weight]
    lite2_weight.must_equal lite1_weight
    lite2_weight.hash.must_equal lite1_weight.hash

    lite1_slice = lite1.characteristics.slice(:weight)
    lite2_slice = lite2.characteristics.slice(:weight)
    lite2_slice.must_equal lite1_slice
    lite2_slice.hash.must_equal lite1_slice.hash
  end

  it "marshal" do
    spaceship = Spaceship.new :name => 'Amaroq', :weight => 1_000_000
    Marshal.load(Marshal.dump(spaceship.characteristics)).must_be_kind_of Charisma::Curator
    Marshal.load(Marshal.dump(spaceship.characteristics))[:name].value.must_equal 'Amaroq'
    Marshal.load(Marshal.dump(spaceship.characteristics))[:weight].to_s.must_equal '1,000,000 hg'
  end
end
