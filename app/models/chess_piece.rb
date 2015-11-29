# Chess piece model
class ChessPiece < ActiveRecord::Base
  BOARD_START_INDEX = 1
  BOARD_END_INDEX = 8

  belongs_to :player, class_name: 'User'
  belongs_to :game

  validates :type,
            :position_x,
            :position_y,
            :color,
            presence: true
  enum color: [:black, :white]

  scope :with_color, ->(color) { where(color: colors[color]) }

  def obstructed?(destination_x, destination_y)
    return diagonal_obstruction?(destination_x, destination_y) if diagonal_move?(destination_x, destination_y)
    return vertical_obstruction?(destination_x, destination_y) if vertical_move?(destination_x, destination_y)
    return horizontal_obstruction?(destination_x, destination_y) if horizontal_move?(destination_x, destination_y)
    fail ArgumentError, 'Invalid move'
  end

  def move_to!(destination_x, destination_y)
    destination_piece = game.chess_pieces.find_by(position_x: destination_x, position_y: destination_y)

    if destination_piece
      fail ArgumentError, 'Invalid Move' if destination_piece.color == color
      destination_piece.destroy
    end
    update(position_x: destination_x, position_y: destination_y)
    game.update_current_player!
  end

  def opposite_color
    black? ? 'white' : 'black'
  end

  private

  def moved?
    updated_at != created_at
  end

  def diagonal_obstruction?(destination_x, destination_y)
    from_x = [position_x, destination_x].min + 1
    from_y = [position_y, destination_y].min + 1
    to_x = [position_x, destination_x].max

    (from_x...to_x).each_with_index do |x, idx|
      return true if position_occupied?(x, from_y + idx)
    end

    false
  end

  def vertical_obstruction?(destination_x, destination_y)
    from_y = [position_y, destination_y].min + 1
    to_y = [position_y, destination_y].max

    (from_y...to_y).each do |y|
      return true if position_occupied?(destination_x, y)
    end

    false
  end

  def horizontal_obstruction?(destination_x, destination_y)
    from_x = [position_x, destination_x].min + 1
    to_x = [position_x, destination_x].max

    (from_x...to_x).each do |x|
      return true if position_occupied?(x, destination_y)
    end

    false
  end

  def position_occupied?(x, y)
    game.chess_pieces.where(position_x: x, position_y: y).present?
  end

  def horizontal_move?(destination_x, destination_y)
    position_y == destination_y && position_x != destination_x
  end

  def vertical_move?(destination_x, destination_y)
    position_x == destination_x && position_y != destination_y
  end

  def diff_in_x(destination_x)
    (destination_x - position_x).abs
  end

  def diff_in_y(destination_y)
    (destination_y - position_y).abs
  end

  def diagonal_move?(destination_x, destination_y)
    diff_in_x(destination_x) == diff_in_y(destination_y)
  end

  def out_of_bounds?(destination_x, destination_y)
    destination_x < BOARD_START_INDEX ||
      destination_x > BOARD_END_INDEX ||
      destination_y < BOARD_START_INDEX ||
      destination_y > BOARD_END_INDEX
  end
end
