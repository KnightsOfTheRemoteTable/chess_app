require 'rails_helper'

RSpec.describe Rook do
  it 'has type of Rook' do
    expect(subject.type).to eq 'Rook'
  end

  describe '#valid_move?' do
    let(:rook) { create(:rook, position_x: 5, position_y: 5) }

    it 'returns true for vertical moves' do
      expect(rook.valid_move?(5, 6)).to eq true
    end

    it 'returns true for horizontal moves' do
      expect(rook.valid_move?(4, 5)).to eq true
    end

    it 'returns false for diagonal moves' do
      expect(rook.valid_move?(4, 4)).to eq false
    end

    it 'returns false for jagged moves' do
      expect(rook.valid_move?(4, 3)).to eq false
    end

    it 'returns false if obstructed' do
      create(:pawn, position_x: 4, position_y: 5, game: rook.game)

      expect(rook.valid_move?(3, 5)).to eq false
    end

    it 'returns false if out of bounds' do
      expect(rook.valid_move?(13, 5)).to eq false
    end
  end
end
