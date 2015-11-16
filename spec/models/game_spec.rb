require 'rails_helper'

RSpec.describe Game do
  it { is_expected.to have_attribute :name }

  it { is_expected.to belong_to :white_player }

  it { is_expected.to belong_to :black_player }

  it { is_expected.to have_many :chess_pieces }

  it { is_expected.to validate_presence_of :name }

  describe 'games#populate_board!' do
    it 'initializes a Black & White King in correct starting position' do
      game = create(:game)
      white_king = game.chess_pieces.where(type: 'King', position_x: 4, position_y: 1).first
      black_king = game.chess_pieces.where(type: 'King', position_x: 4, position_y: 8).last

      expect(white_king.type).to eq 'King'
      expect(black_king.type).to eq 'King'
    end

    it 'initializes a Black & White Queen in correct starting position' do
      game = create(:game)
      white_queen = game.chess_pieces.where(type: 'Queen', position_x: 5, position_y: 1).first
      black_queen = game.chess_pieces.where(type: 'Queen', position_x: 5, position_y: 8).last

      expect(white_queen.type).to eq 'Queen'
      expect(black_queen.type).to eq 'Queen'
    end

    it 'initializes a Black & White Bishop in correct starting position' do
      game = create(:game)

      expect(game.chess_pieces.find_by(type: 'Bishop', position_x: 3, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Bishop', position_x: 6, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Bishop', position_x: 3, position_y: 8).color).to eq 'black'
      expect(game.chess_pieces.find_by(type: 'Bishop', position_x: 6, position_y: 8).color).to eq 'black'
    end

    it 'initializes a Black & White Rook in correct starting position' do
      game = create(:game)

      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 1, position_y: 8).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 8, position_y: 8).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 1, position_y: 1).color).to eq 'black'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 8, position_y: 1).color).to eq 'black'
    end

    it 'initializes a Black & White Pawn in correct starting position' do
      game = create(:game)
      1.upto(8) do |x|
        white_pawn = game.chess_pieces.where(type: 'Pawn', position_x: x, position_y: 2).first
        expect(white_pawn.type).to eq 'Pawn'
      end
    end
  end
end
