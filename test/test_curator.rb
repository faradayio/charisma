require 'helper'

describe Charisma::Curator do
  before do
    @ship = Spaceship.new :window_count => 3, :weight => false
    @curator = Charisma::Curator.new @ship
  end

  describe '#initialize' do
    it 'stores the subject' do
      @curator.subject.must_equal @ship
    end
    it "assigns any characteristics set on subject to the curation's characteristics" do
      @curator.characteristics[:window_count].must_equal 3
    end
    it "assigns characteristics on subject set to `false`" do
      @curator.characteristics[:weight].value.must_equal false
    end
    it "does not assign nil characteristics" do
      @curator.characteristics.keys.wont_include :size
    end
  end

  describe '#characteristics' do
    it 'returns a default value of a nil Curation for valid characteristics' do
      @curator.characteristics[:size].value.must_be_nil
    end
  end

  describe 'LooseEquality' do
    # previously this blew up on 1.8.7
    it '#==' do
      (@curator == @curator).must_equal true
      ship2 = Spaceship.new :window_count => 3
      curator2 = Charisma::Curator.new ship2
      (@curator == curator2).must_equal false
    end
  end
end
