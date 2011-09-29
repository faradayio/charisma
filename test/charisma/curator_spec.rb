require File.expand_path('../spec_helper', File.dirname(__FILE__))
require File.expand_path('../support/spaceship', File.dirname(__FILE__))

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
      @curator.characteristics[:weight].must_be_same_as false
    end
  end

  describe '#characteristics' do
    it 'returns a default value of a nil Curation for valid characteristics' do
      @curator.characteristics[:size].value.must_be_nil
    end
  end
end
