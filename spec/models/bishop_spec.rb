require 'rails_helper'

RSpec.describe Bishop do
  it 'has type of Bishop' do
    expect(subject.type).to eq 'Bishop'
  end

  describe '#valid_move?' do
    let(:bishop) { create(:bishop, position_x: 5, position_y: 5) }

    it 'returns true for diagonal moves' do
      expect(bishop.valid_move?(Coordinates.new(6, 6))).to eq true
    end

    it 'returns false for non-diagonal moves' do
      expect(bishop.valid_move?(Coordinates.new(6, 7))).to eq false
    end

    it 'returns false if obstructed' do
      create(:pawn, position_x: 4, position_y: 4, game: bishop.game)
      expect(bishop.valid_move?(Coordinates.new(3, 3))).to eq false
    end

    it 'returns false if the move is outside the boundaries of the board' do
      bishop = create(:bishop, position_x: 8, position_y: 4)
      expect(bishop.valid_move?(Coordinates.new(12, 8))).to eq false
    end
  end
end
