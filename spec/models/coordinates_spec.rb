require 'spec_helper'

RSpec.describe Coordinates do
  describe '.new' do
    let(:coordinates) { Coordinates.new(3, 4) }

    it 'sets the first argument to x' do
      expect(coordinates.x).to eq 3
    end

    it 'sets the second argument to y' do
      expect(coordinates.y).to eq 4
    end
  end

  describe '#==' do
    it 'returns true if the x and y of the passed in object are the same as those of self' do
      expect(Coordinates.new(1, 1)).to eq Coordinates.new(1, 1)
    end

    it 'returns false for objects that do not respond to x and y' do
      expect(Coordinates.new(1, 1)).to_not eq Object.new
    end

    it 'returns false if x and y are different' do
      expect(Coordinates.new(1, 1)).to_not eq Coordinates.new(1, 2)
    end
  end
end
