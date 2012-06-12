require 'helper'

describe Charisma do
  describe '.characterization' do
    it 'returns a list of all keys' do
      Spaceship.characterization.keys.sort_by { |k| k.to_s }.should ==([:color, :destination, :fuel, :make, :name, :size, :weight, :window_count].sort_by { |k| k.to_s })
    end
  end

  describe '#characteristics' do
    it 'provides a Curation object' do
      ship = Spaceship.new
      ship.characteristics.should be_a(Charisma::Curator)
    end
  end
  
  it 'properly compares different characteristics' do
    # should be different
    lite = Spaceship.new :weight => 1
    heavy = Spaceship.new :weight => 999
    heavy.should_not == lite
    heavy.characteristics.hash.should_not == lite.characteristics.hash

    lite_weight = lite.characteristics[:weight]
    heavy_weight = heavy.characteristics[:weight]
    heavy_weight.should_not == lite_weight
    heavy_weight.hash.should_not == lite_weight.hash

    lite_slice = lite.characteristics.slice(:weight)
    heavy_slice = heavy.characteristics.slice(:weight)
    heavy_slice.should_not == lite_slice
    heavy_slice.hash.should_not == lite_slice.hash

    # should be the same
    lite1 = Spaceship.new :weight => 1
    lite2 = Spaceship.new :weight => 1
    lite2.should == lite1
    lite2.characteristics.hash.should == lite1.characteristics.hash

    lite1_weight = lite1.characteristics[:weight]
    lite2_weight = lite2.characteristics[:weight]
    lite2_weight.should == lite1_weight
    lite2_weight.hash.should == lite1_weight.hash

    lite1_slice = lite1.characteristics.slice(:weight)
    lite2_slice = lite2.characteristics.slice(:weight)
    lite2_slice.should == lite1_slice
    lite2_slice.hash.should == lite1_slice.hash
  end
end
