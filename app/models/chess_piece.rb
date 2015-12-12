# Chess piece model
class ChessPiece < ActiveRecord::Base
  BOARD_START_INDEX = 1
  BOARD_END_INDEX = 8

  belongs_to :player, class_name: 'User'
  belongs_to :game

  validates :type, :position_x, :position_y, :color, presence: true

  enum color: [:black, :white]

  scope :with_color, ->(color) { where(color: colors[color]) }

  def obstructed?(coordinates)
    move_for(coordinates).path.each do |path_coordinates|
      return true if position_occupied?(path_coordinates)
    end
    false
  end

  def move_puts_king_in_check?(coordinates)
    check_state = false

    ActiveRecord::Base.transaction do
      move_to!(coordinates)
      check_state = game.check?
      fail ActiveRecord::Rollback
    end

    reload
    check_state
  end

  def move_to!(coordinates)
    destination_piece = game.chess_pieces.find_by(position_x: coordinates.x, position_y: coordinates.y)
    capture(destination_piece) if destination_piece

    update(position_x: coordinates.x, position_y: coordinates.y)
    game.update(en_passant_position: nil)
    game.update_current_player!(color)
  end

  def opposite_color
    black? ? 'white' : 'black'
  end

  def coordinates
    Coordinates.new(position_x, position_y)
  end

  def moved?
    updated_at != created_at
  end

  def valid_moves
    moves = []
    1.upto(8) do |x|
      1.upto(8) do |y|
        moves << { x: x, y: y } if valid_move?(Coordinates.new(x, y))
      end
    end
    moves
  end

  private

  def move_for(coordinates)
    Move.new(piece: self, destination: coordinates)
  end

  def capture(piece)
    fail ArgumentError, 'Invalid Move' if piece.color == color
    piece.destroy
  end

  def position_occupied?(coordinates)
    game.chess_pieces.where(position_x: coordinates.x, position_y: coordinates.y).present?
  end

  def horizontal_move?(coordinates)
    position_y == coordinates.y && position_x != coordinates.x
  end

  def vertical_move?(coordinates)
    position_x == coordinates.x && position_y != coordinates.y
  end

  def diff_in_x(destination_x)
    (destination_x - position_x).abs
  end

  def diff_in_y(destination_y)
    (destination_y - position_y).abs
  end

  def diagonal_move?(coordinates)
    diff_in_x(coordinates.x) == diff_in_y(coordinates.y)
  end

  def out_of_bounds?(coordinates)
    coordinates.x < BOARD_START_INDEX ||
      coordinates.x > BOARD_END_INDEX ||
      coordinates.y < BOARD_START_INDEX ||
      coordinates.y > BOARD_END_INDEX
  end
end
