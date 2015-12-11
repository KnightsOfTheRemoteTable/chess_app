require 'rails_helper'

RSpec.describe Game do
  let(:game) { create(:game) }

  it { is_expected.to have_attribute :name }
  it { is_expected.to validate_presence_of :name }

  it { is_expected.to have_attribute :en_passant_position }

  it { is_expected.to belong_to :white_player }
  it { is_expected.to belong_to :black_player }
  it { is_expected.to belong_to :winner }

  it { is_expected.to have_many :chess_pieces }

  it { is_expected.to validate_presence_of :name }

  describe '#current_player_is_black_player!' do
    it 'sets the current player of the game to black' do
      game.current_player_is_black_player!

      expect(game.current_player_is_white_player?).to eq false
      expect(game.current_player_is_black_player?).to eq true
    end
  end

  describe '#current_player_is_black_player?' do
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
      game.current_player_is_white_player!

      expect(game.current_player_is_black_player?).to eq false
      expect(game.current_player_is_white_player?).to eq true
    end
  end

  describe '#current_player_is_white_player?' do
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

      expect(game.chess_pieces.find_by(type: 'King', position_x: 4, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'King', position_x: 4, position_y: 8).color).to eq 'black'
    end

    it 'initializes a Black & White Queen in correct starting position' do
      game = create(:game)

      expect(game.chess_pieces.find_by(type: 'Queen', position_x: 5, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Queen', position_x: 5, position_y: 8).color).to eq 'black'
    end

    it 'initializes a Black & White Bishop in correct starting position' do
      expect(game.chess_pieces.find_by(type: 'Bishop', position_x: 3, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Bishop', position_x: 6, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Bishop', position_x: 3, position_y: 8).color).to eq 'black'
      expect(game.chess_pieces.find_by(type: 'Bishop', position_x: 6, position_y: 8).color).to eq 'black'
    end

    it 'initializes a Black & White Rook in correct starting position' do
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 1, position_y: 8).color).to eq 'black'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 8, position_y: 8).color).to eq 'black'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 1, position_y: 1).color).to eq 'white'
      expect(game.chess_pieces.find_by(type: 'Rook', position_x: 8, position_y: 1).color).to eq 'white'
    end

    it 'initializes a Black & White Pawn in correct starting position' do
      1.upto(8) do |x|
        expect(game.chess_pieces.find_by(type: 'Pawn', position_x: x, position_y: 2).color).to eq 'white'
        expect(game.chess_pieces.find_by(type: 'Pawn', position_x: x, position_y: 7).color).to eq 'black'
      end
    end
  end

  describe '#check?' do
    it 'returns false if the game is not in a state of check' do
      expect(game.check?).to eq false
    end

    it 'returns true if the game is in a state of check' do
      # Put the game in check by deleting all black pawns, leaving black king
      # with multiple valid moves; and then placing a white bishop in a position to capture.
      Pawn.destroy_all(color: 'black', game: game)
      create(:bishop, position_x: 2, position_y: 6, color: 'white', game: game)

      expect(game.check?).to eq true
    end
  end

  describe '#stalemate?' do
    it 'returns false if the game is not in a state of stalemate' do
      expect(game.state_of_stalemate?('black')).to eq false
    end

    it 'returns true if the game is in a state of stalemate' do
      game.chess_pieces.destroy_all
      create(:king, position_x: 8, position_y: 1, color: 'black', game: game)
      create(:king, position_x: 6, position_y: 2, color: 'white', game: game)
      create(:queen, position_x: 7, position_y: 3, color: 'white', game: game)

      expect(game.state_of_stalemate?('black')).to eq true
    end
  end

  describe '#checkmate?' do
    def setup_fools_mate(game)
      game.chess_pieces.find_by(position_x: 3, position_y: 2).move_to!(Coordinates.new(3, 3))
      game.chess_pieces.find_by(position_x: 2, position_y: 2).move_to!(Coordinates.new(2, 4))
      game.chess_pieces.find_by(position_x: 5, position_y: 8).move_to!(Coordinates.new(1, 4))
    end

    it 'returns false if the game is not checkmated' do
      game = create(:game)
      expect(game.checkmate?).to eq false
    end

    it 'returns true if either of the kings is in checkmate' do
      game = create(:game)
      setup_fools_mate(game)

      expect(game.checkmate?).to eq true
    end
  end

  describe '#current_player_is_black_player!' do
    it 'sets the current player of the game to black' do
      game.current_player_is_black_player!

      expect(game.current_player_is_white_player?).to eq false
      expect(game.current_player_is_black_player?).to eq true
    end
  end

  describe '#current_player_is_black_player?' do
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
      game.current_player_is_white_player!

      expect(game.current_player_is_black_player?).to eq false
      expect(game.current_player_is_white_player?).to eq true
    end
  end

  describe '#current_player_is_white_player?' do
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
    let(:black_rook) { create(:rook, color: 'black', game: game, position_x: 5, position_y: 5) }
    let(:white_rook) { create(:rook, color: 'white', game: game, position_x: 6, position_y: 6) }

    it 'generates an ArgumentError if a piece of the same color is at the destination' do
      create(:rook, color: 'black', game: game, position_x: 6, position_y: 5)
      expect { black_rook.move_to!(Coordinates.new(6, 5)) }.to raise_error(ArgumentError)
    end

    it 'otherwise updates the current x position of the piece' do
      black_rook.move_to!(Coordinates.new(4, 5))
      expect(black_rook.position_x).to eq 4
    end

    it 'otherwise updates the current y position of the piece' do
      black_rook.move_to!(Coordinates.new(5, 6))
      expect(black_rook.position_y).to eq 6
    end

    it 'when black moves, the current player becomes white' do
      black_rook.move_to!(Coordinates.new(4, 5))
      expect(game.current_player_is_white_player?).to eq true
    end

    it 'when white moves, the current player becomes black' do
      game.current_player_is_white_player!
      white_rook.move_to!(Coordinates.new(7, 6))
      expect(game.current_player_is_black_player?).to eq true
    end
  end
  describe '#forfeit_by!' do
    it 'results in white victory when black forfeits' do
      black_player = create(:user)
      white_player = create(:user)
      game = create(:game, black_player: black_player, white_player: white_player)

      game.forfeit_by!(black_player)

      expect(game.reload.winner).to eq white_player
    end

    it 'results in black victory when white forfeits' do
      black_player = create(:user)
      white_player = create(:user)
      game = create(:game, black_player: black_player, white_player: white_player)

      game.forfeit_by!(white_player)

      expect(game.reload.winner).to eq black_player
    end
  end

  describe '#players' do
    it 'returns both players' do
      black_player = create(:user)
      white_player = create(:user)
      game = create(:game, black_player: black_player, white_player: white_player)

      expect(game.players).to include black_player
      expect(game.players).to include white_player
    end
  end

  describe '#can_en_passant?' do
    it 'returns true when coordinates match en passant position' do
      game.en_passant_position = '1,1'
      expect(game.can_en_passant?(Coordinates.new(1, 1))).to eq true
    end
  end
end
