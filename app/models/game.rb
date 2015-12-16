class Game < ActiveRecord::Base
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

  def full?
    players.count == 2
  end

  def players
    [white_player, black_player].compact
  end

  def includes_player?(player)
    players.include?(player)
  end

  def populate_board!
    create_knights
    create_queens
    create_bishops
    create_rooks
    create_pawns
    current_player_is_white_player!
  end

  def create_knights
    chess_pieces.create(type: 'Knight', position_x: 2, position_y: 1, color: :white)
    chess_pieces.create(type: 'Knight', position_x: 7, position_y: 1, color: :white)
    chess_pieces.create(type: 'Knight', position_x: 2, position_y: 8, color: :black)
    chess_pieces.create(type: 'Knight', position_x: 7, position_y: 8, color: :black)
  end

  def create_queens
    chess_pieces.create(type: 'King', position_x: 5, position_y: 1, color: :white)
    chess_pieces.create(type: 'King', position_x: 5, position_y: 8, color: :black)
    chess_pieces.create(type: 'Queen', position_x: 4, position_y: 1, color: :white)
    chess_pieces.create(type: 'Queen', position_x: 4, position_y: 8, color: :black)
  end

  def create_bishops
    chess_pieces.create(type: 'Bishop', position_x: 3, position_y: 1, color: :white)
    chess_pieces.create(type: 'Bishop', position_x: 6, position_y: 1, color: :white)
    chess_pieces.create(type: 'Bishop', position_x: 3, position_y: 8, color: :black)
    chess_pieces.create(type: 'Bishop', position_x: 6, position_y: 8, color: :black)
  end

  def create_rooks
    chess_pieces.create(type: 'Rook', position_x: 1, position_y: 8, color: :black)
    chess_pieces.create(type: 'Rook', position_x: 8, position_y: 8, color: :black)
    chess_pieces.create(type: 'Rook', position_x: 1, position_y: 1, color: :white)
    chess_pieces.create(type: 'Rook', position_x: 8, position_y: 1, color: :white)
  end

  def create_pawns
    1.upto(8) do |x|
      chess_pieces.create(type: 'Pawn', position_x: x, position_y: 2, color: :white)
      chess_pieces.create(type: 'Pawn', position_x: x, position_y: 7, color: :black)
    end
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

  private

  def en_passant_coordinates
    return unless en_passant_position
    Coordinates.new(*en_passant_position.split(',').map(&:to_i))
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
end
