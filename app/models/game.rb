class Game < ActiveRecord::Base
  HOME_RANK = %w(
    Rook
    Knight
    Bishop
    King
    Queen
    Bishop
    Knight
    Rook
  )

  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
  belongs_to :winner, class_name: 'User'

  has_many :chess_pieces

  validates :name, presence: true

  enum current_player: [:current_player_is_black_player,
                        :current_player_is_white_player]

  scope :active, -> { where(winner: nil) }

  after_create :populate_board!

  def forfeit_by!(player)
    if player == white_player
      winner = black_player
    else
      winner = white_player
    end
    update!(winner: winner)
  end

  def players
    [white_player, black_player].compact
  end

  def populate_board!
    create_home_rank
    create_pawns
    current_player_is_white_player!
  end

  def state_of_stalemate?(color)
    chess_pieces.with_color(color).each do |piece|
      potential_moves = piece.load_potential_moves
      potential_moves.each { |move| return false if piece.valid_move?(move) && !(piece.move_puts_king_in_check?(move)) }
    end
    true
  end

  def check?
    king_is_in_check?('black') || king_is_in_check?('white')
  end

  def king_is_in_check?(color)
    king = locate_king(color)
    capturable_by_opposing_color?(king)
  end

  def update_current_player!(color)
    color == 'white' ? current_player_is_black_player! : current_player_is_white_player!
  end

  def can_en_passant?(coordinates)
    coordinates == en_passant_coordinates
  end

  def checkmate?
    black_king.checkmate? || white_king.checkmate?
  end

  private

  def en_passant_coordinates
    return unless en_passant_position
    Coordinates.new(*en_passant_position.split(',').map(&:to_i))
  end

  def black_king
    locate_king(:black)
  end

  def white_king
    locate_king(:white)
  end

  def locate_king(color)
    chess_pieces.with_color(color).find_by(type: 'King')
  end

  def capturable_by_opposing_color?(king)
    chess_pieces.with_color(king.opposite_color).find_each do |opponent|
      return true if opponent.valid_move?(king.coordinates)
    end
    false
  end

  def create_home_rank
    HOME_RANK.each_with_index do |type, index|
      chess_pieces.create(type: type, position_x: index + 1, position_y: 1, color: :white)
      chess_pieces.create(type: type, position_x: index + 1, position_y: 8, color: :black)
    end
  end

  def create_pawns
    1.upto(8) do |x|
      chess_pieces.create(type: 'Pawn', position_x: x, position_y: 2, color: :white)
      chess_pieces.create(type: 'Pawn', position_x: x, position_y: 7, color: :black)
    end
  end
end
