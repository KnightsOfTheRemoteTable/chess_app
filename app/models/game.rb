# Chess game model
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
  has_many :chess_pieces

  validates :name, presence: true

  enum current_player: [:current_player_is_black_player,
                        :current_player_is_white_player]

  after_create :populate_board!

  def populate_board!
    create_knights
    create_queens
    create_bishops
    create_rooks
    create_pawns
  end

  def create_knights
    # Create white & Black Knight
    chess_pieces.create(type: 'Knight', position_x: 2, position_y: 1, color: :white)
    chess_pieces.create(type: 'Knight', position_x: 7, position_y: 1, color: :white)
    chess_pieces.create(type: 'Knight', position_x: 2, position_y: 8, color: :black)
    chess_pieces.create(type: 'Knight', position_x: 7, position_y: 8, color: :black)
  end

  def create_queens
    # Create White & Black Queen
    chess_pieces.create(type: 'King', position_x: 5, position_y: 1, color: :white)
    chess_pieces.create(type: 'King', position_x: 5, position_y: 8, color: :black)

    # Create white & Black Queen
    chess_pieces.create(type: 'Queen', position_x: 4, position_y: 1, color: :white)
    chess_pieces.create(type: 'Queen', position_x: 4, position_y: 8, color: :black)
  end

  def create_bishops
    # Create White & Black Bishop
    chess_pieces.create(type: 'Bishop', position_x: 3, position_y: 1, color: :white)
    chess_pieces.create(type: 'Bishop', position_x: 6, position_y: 1, color: :white)
    chess_pieces.create(type: 'Bishop', position_x: 3, position_y: 8, color: :black)
    chess_pieces.create(type: 'Bishop', position_x: 6, position_y: 8, color: :black)
  end

  def create_rooks
    # Create white & Black Rook
    chess_pieces.create(type: 'Rook', position_x: 1, position_y: 8, color: :black)
    chess_pieces.create(type: 'Rook', position_x: 8, position_y: 8, color: :black)
    chess_pieces.create(type: 'Rook', position_x: 1, position_y: 1, color: :white)
    chess_pieces.create(type: 'Rook', position_x: 8, position_y: 1, color: :white)
  end

  def create_pawns
    # Create White & Black Pawn
    1.upto(8) do |x|
      chess_pieces.create(type: 'Pawn', position_x: x, position_y: 2, color: :white)
      chess_pieces.create(type: 'Pawn', position_x: x, position_y: 7, color: :black)
    end
  end

  def check?
    king_is_in_check?('black') || king_is_in_check?('white')
  end

  private

  def king_is_in_check?(color)
    king = locate_king(color)
    capturable_by_opposing_color?(king)
  end

  def locate_king(color)
    chess_pieces.with_color(color).find_by(type: 'King')
  end

  def capturable_by_opposing_color?(king)
    chess_pieces.with_color(king.opposite_color).find_each do |opponent|
      return true if opponent.valid_move?(king.position_x, king.position_y)
    end
    false
  end
end
