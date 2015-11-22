require 'rails_helper'

RSpec.describe Queen do
  it 'has type of Queen' do
    expect(subject.type).to eq 'Queen'
  end

  describe '#valid_move?' do
    let(:queen) { create(:queen, position_x: 3, position_y: 3) }

    it 'returns true for vertical moves' do
      expect(queen.valid_move?(3, 6)).to eq true
    end

    it 'returns true for horizontal moves' do
      expect(queen.valid_move?(4, 3)).to eq true
    end

    it 'returns true for diagonal moves' do
      expect(queen.valid_move?(1, 5)).to eq true
    end

    it 'returns false for moves that are not straight lines' do
      expect(queen.valid_move?(4, 5)).to eq false
    end

    it 'returns false if obstructed' do
      create(:pawn, position_x: 3, position_y: 4, game: queen.game)

      expect(queen.valid_move?(3, 5)).to eq false
    end

    it 'returns false if out of bounds' do
      expect(queen.valid_move?(13, 3)).to eq false
    end
  end
end
