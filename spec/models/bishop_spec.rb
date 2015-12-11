require 'rails_helper'

RSpec.describe Bishop do
  it 'has type of Bishop' do
    expect(subject.type).to eq 'Bishop'
  end

  describe '#valid_move?' do
    let(:bishop) { create(:bishop, position_x: 5, position_y: 5) }
    let(:game)   { create(:game) }

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

    it 'returns false if the king would be put in check' do
      remove_everything_but_king!('black')
      bishop = create(:bishop, position_x: 6, position_y: 7, color: 'black', game: game)
      create(:bishop, position_x: 7, position_y: 6, color: 'white', game: game)
      expect(bishop.valid_move?(Coordinates.new(5, 6))).to eq false
    end
  end
end

def remove_everything_but_king!(color)
  Pawn.with_color(color).destroy_all(game: game)
  Knight.with_color(color).destroy_all(game: game)
  Bishop.with_color(color).destroy_all(game: game)
  Queen.with_color(color).destroy_all(game: game)
  Rook.with_color(color).destroy_all(game: game)
end
