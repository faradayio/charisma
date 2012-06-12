require 'helper'

describe Charisma::NumberHelper do
  describe '.delimit' do
    it 'adds a comma delimiter to numbers above 1,000' do
      Charisma::NumberHelper.delimit(1_000).should == '1,000'
    end
  end
end

