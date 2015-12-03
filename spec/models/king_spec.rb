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

    context 'when black king tries to castle with no obstructions' do
      before(:each) do
        remove_everything_but_rook_and_king!('black')
      end

      it 'returns false if the black kingside rook has previously moved' do
        black_kingside_rook.move_to!(Coordinates.new(8, 4))

        expect(black_king.can_castle?(black_kingside_rook)).to eq false
      end

      it 'returns false if the black queenside rook has previously moved' do
        black_queenside_rook.move_to!(Coordinates.new(1, 4))

        expect(black_king.can_castle?(black_queenside_rook)).to eq false
      end

      it 'returns false if the black king has previously moved' do
        black_king.move_to!(Coordinates.new(5, 7))

        expect(black_king.can_castle?(black_kingside_rook)).to eq false
      end
    end

    context 'when black king tries to castle with an obstruction' do
      it 'returns false if there is an obstruction on black kingside' do
        expect(black_king.can_castle?(black_kingside_rook)).to eq false
      end

      it 'returns false if there is an obstruction on black queenside' do
        expect(black_king.can_castle?(black_queenside_rook)).to eq false
      end
    end

    context 'when white king tries to castle with no obstructions' do
      before(:each) do
        remove_everything_but_rook_and_king!('white')
      end

      it 'returns false if the white kingside rook has previously moved' do
        white_kingside_rook.move_to!(Coordinates.new(8, 4))

        expect(white_king.can_castle?(white_kingside_rook)).to eq false
      end

      it 'returns false if the white queenside rook has previously moved' do
        white_queenside_rook.move_to!(Coordinates.new(1, 5))

        expect(white_king.can_castle?(white_queenside_rook)).to eq false
      end

      it 'returns false if the white king has previously moved' do
        white_king.move_to!(Coordinates.new(5, 7))

        expect(white_king.can_castle?(white_kingside_rook)).to eq false
      end
    end

    context 'when white king tries to castle with an obstruction' do
      it 'returns false if there is an obstruction on white kingside' do
        expect(white_king.can_castle?(white_kingside_rook)).to eq false
      end

      it 'returns false if there is an obstruction on white queenside' do
        expect(white_king.can_castle?(white_queenside_rook)).to eq false
      end
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
      expect(black_king.reload.position_x).to eq 7
    end

    it 'updates the x coordinates of the black king when castling queenside'do
      remove_everything_but_rook_and_king!('black')
      black_king.castle!(black_queenside_rook)
      expect(black_king.reload.position_x).to eq 3
    end

    it 'updates the x coordinates of the black rook when castling kingside'do
      remove_everything_but_rook_and_king!('black')
      black_king.castle!(black_kingside_rook)
      expect(black_kingside_rook.reload.position_x).to eq 6
    end

    it 'updates the x coordinates of the black rook when castling queenside'do
      remove_everything_but_rook_and_king!('black')
      black_king.castle!(black_queenside_rook)
      expect(black_queenside_rook.reload.position_x).to eq 4
    end

    it 'updates the x coordinates of the white king when castling kingside'do
      remove_everything_but_rook_and_king!('white')
      expect(white_king.can_castle?(white_kingside_rook)).to eq true
      white_king.castle!(white_kingside_rook)
      expect(white_king.reload.position_x).to eq 7
    end

    it 'updates the x coordinates of the white king when castling queenside'do
      remove_everything_but_rook_and_king!('white')
      white_king.castle!(white_queenside_rook)
      expect(white_king.reload.position_x).to eq 3
    end

    it 'updates the x coordinates of the white rook when castling kingside'do
      remove_everything_but_rook_and_king!('white')
      white_king.castle!(white_kingside_rook)
      expect(white_kingside_rook.reload.position_x).to eq 6
    end

    it 'updates the x coordinates of the white rook when castling queenside'do
      remove_everything_but_rook_and_king!('white')
      white_king.castle!(white_queenside_rook)
      expect(white_queenside_rook.reload.position_x).to eq 4
    end
  end
end

def remove_everything_but_rook_and_king!(color)
  Pawn.with_color(color).destroy_all(game: game)
  Knight.with_color(color).destroy_all(game: game)
  Bishop.with_color(color).destroy_all(game: game)
  Queen.with_color(color).destroy_all(game: game)
end
