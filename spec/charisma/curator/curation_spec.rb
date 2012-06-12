require 'helper'

describe Charisma::Curator::Curation do
  let(:spaceship) { Spaceship.new }
  let(:curator) { Charisma::Curator.new spaceship }

  let(:destination) { curator[:destination] }
  let(:fuel) { curator[:fuel] }
  let(:make) { curator[:make] }
  let(:name) { curator[:name] }
  let(:size) { curator[:size] }
  let(:weight) { curator[:weight] }
  let(:window_count) { curator[:window_count] }

  describe '#to_s' do
    it 'outputs a simple characteristic' do
      spaceship.name = 'Amaroq' 
      name.to_s.should == 'Amaroq'
    end
    it 'outputs a measured characteristic' do
      spaceship.size = 10
      size.to_s.should == '10 m'
    end
    it 'outputs a classified characteristic' do
      spaceship.weight = 1_000_000
      weight.to_s.should == '1,000,000 hg'
    end
    
    it "attribute_with_custom_display" do
      spaceship.window_count = 10
      window_count.to_s.should == '10 windows'
    end
    
    it "simple_association" do
      spaceship.destination = Planet.create :name => 'Pluto'
      destination.to_s.should == 'Pluto'
    end
    
    it "association_with_display_hint" do
      spaceship.make = SpaceshipMake.create :name => 'Boeing'
      make.to_s.should == 'Boeing'
    end
    
    it "association_with_prepared_display" do
      spaceship.fuel = SpaceshipFuel.create :name => 'Kerosene', :emission_factor => 10
      fuel.to_s.should == 'Kerosene (10 kg CO2/L)'
    end
  end

  describe '#units' do
    it 'outputs units' do
      spaceship = Spaceship.new :weight => '1000000.1' # kg
      weight.units.should == :hollagrams
    end
  end
  describe '#u' do
    it 'returns abbreviated units' do
      weight.u.should == 'hg'
    end
  end

  it 'converts units' do
    spaceship.weight = 1_000_000.1
    weight.supertons.should == 2_000_000.2
  end

  describe '#inspect' do
    it 'outputs defined characterstics' do

    end
    it 'reports undefined characteristics' do
      muktruk = Spaceship.new
      muktruk.characteristics[:bumper_sticker] = 'LT'
      muktruk.characteristics[:bumper_sticker].inspect.should =~ /undefined characteristic/
    end
  end

  describe 'operators' do
    it 'delegates operators to the curation value' do
      amaroq = Charisma::Curator::Curation.new 8
      geo = Charisma::Curator::Curation.new 6
      (amaroq - geo).should == 2
    end
  end
end

