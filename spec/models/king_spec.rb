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
    let(:game)           { create(:game) }
    let(:black_king)     { game.chess_pieces.find_by(position_x: 5, position_y: 8) }
    let(:white_king)     { game.chess_pieces.find_by(position_x: 5, position_y: 1) }
    let(:black_kingside_rook)  { game.chess_pieces.find_by(position_x: 8, position_y: 8) }
    let(:black_queenside_rook) { game.chess_pieces.find_by(position_x: 1, position_y: 8) }
    let(:white_kingside_rook)  { game.chess_pieces.find_by(position_x: 8, position_y: 1) }
    let(:white_queenside_rook) { game.chess_pieces.find_by(position_x: 1, position_y: 1) }

    it 'returns false if the black kingside rook has previously moved' do
      remove_everything_but_rook_and_king!('black')
      black_kingside_rook.move_to!(Coordinates.new(8, 4))

      expect(black_king.can_castle?(black_kingside_rook)).to eq false
    end

    it 'returns false if the black queenside rook has previously moved' do
      remove_everything_but_rook_and_king!('black')
      black_queenside_rook.move_to!(Coordinates.new(1, 4))

      expect(black_king.can_castle?(black_queenside_rook)).to eq false
    end

    it 'returns false if the black king has previously moved' do
      remove_everything_but_rook_and_king!('black')
      black_king.move_to!(Coordinates.new(5, 7))

      expect(black_king.can_castle?(black_kingside_rook)).to eq false
    end

    it 'returns false if there is an obstruction on black kingside' do
      expect(black_king.can_castle?(black_kingside_rook)).to eq false
    end

    it 'returns false if there is an obstruction on black queenside' do
      expect(black_king.can_castle?(black_queenside_rook)).to eq false
    end

    it 'returns false if the white kingside rook has previously moved' do
      remove_everything_but_rook_and_king!('white')
      white_kingside_rook.move_to!(Coordinates.new(8, 4))

      expect(white_king.can_castle?(white_kingside_rook)).to eq false
    end

    it 'returns false if the white queenside rook has previously moved' do
      remove_everything_but_rook_and_king!('white')
      white_queenside_rook.move_to!(Coordinates.new(1, 5))

      expect(white_king.can_castle?(white_queenside_rook)).to eq false
    end

    it 'returns false if the white king has previously moved' do
      remove_everything_but_rook_and_king!('white')
      white_king.move_to!(Coordinates.new(5, 7))

      expect(white_king.can_castle?(white_kingside_rook)).to eq false
    end

    it 'returns false if there is an obstruction on white kingside' do
      expect(white_king.can_castle?(white_kingside_rook)).to eq false
    end

    it 'returns false if there is an obstruction on white queenside' do
      expect(white_king.can_castle?(white_queenside_rook)).to eq false
    end

    it 'returns false if the king crosses any square that would put the game in check' do
      remove_everything_but_rook_and_king!('black')
      Rook.create(position_x: 6, position_y: 6, color: 'white', game: game)

      expect(black_king.can_castle?(black_kingside_rook)).to eq false
    end

    it 'returns true otherwise' do
      remove_everything_but_rook_and_king!('black')

      expect(black_king.can_castle?(black_kingside_rook)).to eq true
    end
  end

  describe '#castle!' do
    let(:game)                 { create(:game) }
    let(:black_king)           { game.chess_pieces.find_by(position_x: 5, position_y: 8) }
    let(:white_king)           { game.chess_pieces.find_by(position_x: 5, position_y: 1) }
    let(:black_kingside_rook)  { game.chess_pieces.find_by(position_x: 8, position_y: 8) }
    let(:black_queenside_rook) { game.chess_pieces.find_by(position_x: 1, position_y: 8) }
    let(:white_kingside_rook)  { game.chess_pieces.find_by(position_x: 8, position_y: 1) }
    let(:white_queenside_rook) { game.chess_pieces.find_by(position_x: 1, position_y: 1) }

    it 'updates the x coordinates of the black king when castling kingside'do
      remove_everything_but_rook_and_king!('black')
      black_king.castle!(black_kingside_rook)
      expect(black_king.position_x).to eq 7
    end

    it 'updates the x coordinates of the black rook when castling kingside'do
      remove_everything_but_rook_and_king!('black')
      black_king.castle!(black_kingside_rook)
      expect(black_kingside_rook.position_x).to eq 6
    end

    it 'swaps the x coordinates of the black king and the black queenside rook'
    it 'swaps the x coordinates of the white king and the white kingside rook'
    it 'swaps the x coordinates of the white king and the white queenside rook'
  end
end

def remove_everything_but_rook_and_king!(color)
  Pawn.destroy_all(color:   color, game: game)
  Knight.destroy_all(color: color, game: game)
  Bishop.destroy_all(color: color, game: game)
  Queen.destroy_all(color:  color, game: game)
end
