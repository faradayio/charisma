require 'helper'

describe Charisma::Curator do
  let(:ship) { Spaceship.new }
  let(:curator) { Charisma::Curator.new ship }

  describe '#initialize' do
    it 'stores the subject' do
      curator.subject.should == ship
    end
    it "assigns any characteristics set on subject to the curation's characteristics" do
      ship.window_count = 3
      curator[:window_count].should == 3
    end
    it "assigns characteristics on subject set to `false`" do
      ship.weight = false
      curator[:weight].value.should == false
    end
    it 'returns a default value of a nil Curation for valid characteristics' do
      curator[:size].value.should be_nil
    end
    it "does not assign nil characteristics" do
      ship.size = nil
      curator.keys.should_not include(:size)
    end
    it 'curates associations' do
      ship.destination = Planet.create :name => 'Pluto'
      curator[:destination].mass.should == BigDecimal('1.31e+1_022')
    end
    it 'allows access to missing attributes' do
      curator[:size].class.should == Charisma::Curator::Curation
      curator[:size].value.should == nil
    end
  end

  describe '#keys' do
    it 'returns an array of keys for present characteristics' do
      ship.name = 'Amaroq'
      curator.keys.sort_by { |k| k.to_s }.should == [:name]
    end
  end

  describe '#as_json' do
    it 'returns a hash representation of characteristics' do
      planet = Planet.create :name => 'Pluto'
      spaceship = Spaceship.new :weight => 100, :window_count => 3, :destination => planet
      curator = Charisma::Curator.new spaceship
      curator[:weight].as_json.should == {:value => 100, :units => 'hollagrams'}
      curator[:window_count].as_json.should == 3
      curator[:destination].as_json.should == {:name => 'Pluto'}
    end
  end
  
  describe "#to_hash" do
    it 'returns a hash of curated characteristics' do
      spaceship = Spaceship.new :name => 'Amaroq', :window_count => 2, :size => 10
      spaceship.characteristics.to_hash.should ==({:name => 'Amaroq', :window_count => 2, :size => 10})
    end
  end

  describe '#slice' do
    let(:slice) do
      ship.update_attributes :name => 'Amaroq', :window_count => 2, :size => 10
      curator.slice(:size, :window_count)
    end

    it 'returns a list of desired characteristics' do
      slice.values.length.should == 2
      slice[:size].to_s.should == '10 m'
    end
    it 'leaves out unspecified characteristics' do
      slice[:name].should be_nil
    end
  end

  describe '#each' do
    it 'iterates through curations' do
      ship.name = 'Amaroq'
      expect do
        ship.characteristics.each do |k, v|
          throw :blam if k == :name
        end
      end.to throw_symbol(:blam)
    end
  end

  describe '#==' do
    it 'compares to other Curators' do
      amaroq = Charisma::Curator.new(Spaceship.new :window_count => 8)
      buster = Charisma::Curator.new(Spaceship.new :window_count => 8)
      buster.should == amaroq
    end
    it 'properly compares a curator to itself' do
      (curator == curator).should be_true
    end
    it 'returns false for unequal curators' do
      ship2 = Spaceship.new :window_count => 3
      curator2 = Charisma::Curator.new ship2
      (curator == curator2).should be_false
    end
    it 'compares to hashes' do
      amaroq = Spaceship.new :window_count => 8
      amaroq.characteristics.should == { :window_count => 8 }
    end
  end

  describe '#[]=' do
    it 'assigns values of RHS curations' do
      geo = SpaceshipMake.create :name => 'Geo'
      g = Spaceship.new :make => geo
      g.characteristics[:name] = g.characteristics[:make]
      g.characteristics[:name].to_s.should == 'Geo'
    end
  end

  it "can be marshaled" do
    ship.update_attributes :name => 'Amaroq', :weight => 1_000_000
    Marshal.load(Marshal.dump(curator)).should be_a(Charisma::Curator)
    Marshal.load(Marshal.dump(curator))[:name].value.should == 'Amaroq'
    Marshal.load(Marshal.dump(curator))[:weight].to_s.should == '1,000,000 hg'
  end
end
