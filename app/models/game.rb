# Chess game model
class Game < ActiveRecord::Base
  belongs_to :white_player, class_name: 'User'
  belongs_to :black_player, class_name: 'User'
  has_many :chess_pieces

  validates :name, presence: true

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
    chess_pieces.create(type: 'King', position_x: 4, position_y: 1, color: :white)
    chess_pieces.create(type: 'King', position_x: 4, position_y: 8, color: :black)

    # Create white & Black Queen
    chess_pieces.create(type: 'Queen', position_x: 5, position_y: 1, color: :white)
    chess_pieces.create(type: 'Queen', position_x: 5, position_y: 8, color: :black)
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
    chess_pieces.create(type:  'Rook', position_x: 1, position_y: 8, color: :white)
    chess_pieces.create(type:  'Rook', position_x: 8, position_y: 8, color: :white)
    chess_pieces.create(type:  'Rook', position_x: 1, position_y: 1, color: :black)
    chess_pieces.create(type:  'Rook', position_x: 8, position_y: 1, color: :black)
  end

  def create_pawns
    # Create White & Black Pawn
    1.upto(8) do |x|
      chess_pieces.create(type: 'Pawn', position_x: x, position_y: 2, color: :white)
    end

    1.upto(8) do |x|
      chess_pieces.create(type: 'Pawn', position_x: x, position_y: 7, color: :black)
    end
  end
end
