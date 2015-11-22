require 'rails_helper'

RSpec.describe Bishop do
  it 'has type of Bishop' do
    expect(subject.type).to eq 'Bishop'
  end

  describe '#valid_move?' do
    let(:bishop) { create(:bishop, position_x: 3, position_y: 3) }

    it 'returns true for vertical moves' do
      expect(bishop.valid_move?(6, 6)).to eq true
    end

    it 'returns false for non-diagonal lines' do
      expect(bishop.valid_move?(6, 7)).to eq false
    end

    it 'returns false if obstructed' do
      create(:pawn, position_x: 7, position_y: 7)
      expect(bishop.valid_move?(8, 8)).to eq false
    end
  end
end
