require 'rails_helper'

RSpec.describe King do
  it 'has type of King' do
    expect(subject.type).to eq 'King'
  end

  describe '#valid_move?' do
    let(:king) { create(:king, position_x: 4, position_y: 4) }

    it 'returns true when a proposed move is within the movement abilities of the piece' do
      expect(king.valid_move?(Coordinates.new(5, 5))).to be true
    end

    it 'returns false when a proposed move is not within the movement abilities of the piece' do
      expect(king.valid_move?(Coordinates.new(6, 6))).to be false
    end

    it 'returns false when a proposed move is not a straight line' do
      expect(king.valid_move?(Coordinates.new(6, 7))).to eq false
    end

    it 'returns false if out of bounds' do
      king = create(:king, position_x: 1, position_y: 4)
      expect(king.valid_move?(Coordinates.new(0, 4))).to eq false
    end
  end

  describe '#can_castle' do
    let(:game) { create(:game) }
    let(:king) { game.chess_pieces.find_by(position_x: 5, position_y: 8) }
    let(:rook) { game.chess_pieces.find_by(position_x: 1, position_y: 8) }

    it 'returns false if a rook has previously moved' do
      remove_everything_but_rook_and_king!('black')
      rook.move_to!(Coordinates.new(1, 4))

      expect(king.can_castle?(rook)).to eq false
    end

    it 'returns false if the king has previously moved' do
      remove_everything_but_rook_and_king!('black')
      king.move_to!(Coordinates.new(5, 7))

      expect(king.can_castle?(rook)).to eq false
    end

    it 'returns false if, when trying to castle queenside, there is an obstruction' do
      expect(king.can_castle?(rook)).to eq false
    end

    it 'returns false if, when trying to castle kingside, there is an obstruction' do
      expect(king.can_castle?(rook)).to eq false
    end

    it 'returns false if the king crosses any square that would put the game in check' do
      remove_everything_but_rook_and_king!('black')
      Bishop.create(position_x: 7, position_y: 7, color: 'white', game: game)

      expect(king.can_castle?(rook)).to eq false
    end
  end
end

def remove_everything_but_rook_and_king!(color)
  Pawn.destroy_all(color:   color, game: game)
  Knight.destroy_all(color: color, game: game)
  Bishop.destroy_all(color: color, game: game)
  Queen.destroy_all(color:  color, game: game)
end
