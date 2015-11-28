require 'rails_helper'

RSpec.describe Game do
  it { is_expected.to have_attribute :name }
  it { is_expected.to validate_presence_of :name }

  it { is_expected.to belong_to :white_player }
  it { is_expected.to belong_to :black_player }

  it { is_expected.to have_many :chess_pieces }

  it { is_expected.to validate_presence_of :name }

  describe '#current_player_is_black_player!' do
    it 'sets the current player of the game to black' do
      game = create(:game)
      game.current_player_is_black_player!

      expect(game.current_player_is_white_player?).to eq false
      expect(game.current_player_is_black_player?).to eq true
    end
  end

  describe '#current_player_is_black_player?' do
    let(:game) { create(:game) }
    it 'returns true if the current player of the game is the black player' do
      game.current_player_is_black_player!
      expect(game.current_player_is_black_player?).to eq true
    end

    it 'returns false otherwise' do
      game.current_player_is_white_player!
      expect(game.current_player_is_black_player?).to eq false
    end
  end

  describe '#current_player_is_white_player!' do
    it 'sets the current player of the game to white' do
      game = create(:game)
      game.current_player_is_white_player!

      expect(game.current_player_is_black_player?).to eq false
      expect(game.current_player_is_white_player?).to eq true
    end
  end

  describe '#current_player_is_white_player?' do
    let(:game) { create(:game) }
    it 'returns true if the current player of the game is the white player' do
      game.current_player_is_white_player!
      expect(game.current_player_is_white_player?).to eq true
    end

    it 'returns false otherwise' do
      game.current_player_is_black_player!
      expect(game.current_player_is_white_player?).to eq false
    end
  end

  describe 'games#populate_board!' do
    it 'initializes a Black & White King in correct starting position' do
      game = create(:game)

      expect(game.chess_pieces.find_by(type: 'King', position_x: 5, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'King', position_x: 5, position_y: 8).color).to eq 'black'
    end

    it 'initializes a Black & White Queen in correct starting position' do
      game = create(:game)

      expect(game.chess_pieces.find_by(type: 'Queen', position_x: 4, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Queen', position_x: 4, position_y: 8).color).to eq 'black'
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

      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 1, position_y: 8).color).to eq 'black'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 8, position_y: 8).color).to eq 'black'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 1, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 8, position_y: 1).color).to eq 'white'
    end

    it 'initializes a Black & White Pawn in correct starting position' do
      game = create(:game)
      1.upto(8) do |x|
        expect(game.chess_pieces.find_by(type: 'Pawn', position_x: x, position_y: 2).color).to eq 'white'
        expect(game.chess_pieces.find_by(type: 'Pawn', position_x: x, position_y: 7).color).to eq 'black'
      end
    end
  end

  describe '#check?' do
    it 'returns false if the game is not in a state of check' do
      game = create(:game)
      expect(game.check?).to eq false
    end

    it 'returns true if the game is in a state of check' do
      # Put the game in check by deleting all black pawns, leaving black king
      # with multiple valid moves; and then placing a white bishop in a position to capture.
      game = create(:game)
      Pawn.destroy_all(color: 'black', game: game)
      create(:bishop, position_x: 3, position_y: 6, color: 'white', game: game)

      expect(game.check?).to eq true
    end
  end

  describe '#current_player_is_black_player!' do
    it 'sets the current player of the game to black' do
      game = create(:game)
      game.current_player_is_black_player!

      expect(game.current_player_is_white_player?).to eq false
      expect(game.current_player_is_black_player?).to eq true
    end
  end

  describe '#current_player_is_black_player?' do
    let(:game) { create(:game) }

    it 'returns true if the current player of the game is the black player' do
      game.current_player_is_black_player!
      expect(game.current_player_is_black_player?).to eq true
    end

    it 'returns false otherwise' do
      game.current_player_is_white_player!
      expect(game.current_player_is_black_player?).to eq false
    end
  end

  describe '#current_player_is_white_player!' do
    it 'sets the current player of the game to white' do
      game = create(:game)
      game.current_player_is_white_player!

      expect(game.current_player_is_black_player?).to eq false
      expect(game.current_player_is_white_player?).to eq true
    end
  end

  describe '#current_player_is_white_player?' do
    let(:game) { create(:game) }
    it 'returns true if the current player of the game is the white player' do
      game.current_player_is_white_player!
      expect(game.current_player_is_white_player?).to eq true
    end

    it 'returns false otherwise' do
      game.current_player_is_black_player!
      expect(game.current_player_is_white_player?).to eq false
    end
  end

  describe '#move_to' do
    let(:game) { create(:game) }
    let(:black_rook) { create(:rook, color: 'black', game: game, position_x: 5, position_y: 5) }
    let(:white_rook) { create(:rook, color: 'white', game: game, position_x: 6, position_y: 6) }

    it 'generates an ArgumentError if a piece of the same color is at the destination' do
      _occupying_rook = create(:rook, color: 'black', game: game, position_x: 6, position_y: 5)
      expect { black_rook.move_to!(6, 5) }.to raise_error(ArgumentError)
    end

    it 'otherwise updates the current position of the piece' do
      black_rook.move_to!(4, 5)
      expect(black_rook.position_x).to eq 4
    end

    it 'when moved successfully, it switches the current player to white when black moves' do
      black_rook.move_to!(4, 5)
      expect(black_rook.game.current_player_is_white_player?).to eq true
    end

    it 'when moved successfully, it switches the current player to black when white moves' do
      game.current_player_is_white_player!
      white_rook.move_to!(7, 6)
      expect(white_rook.game.current_player_is_black_player?).to eq true
    end
  end
end
