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
end
