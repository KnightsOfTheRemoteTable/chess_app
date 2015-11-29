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

  def obstructed?(coordinates)
    return diagonal_obstruction?(coordinates) if diagonal_move?(coordinates)
    return vertical_obstruction?(coordinates) if vertical_move?(coordinates)
    return horizontal_obstruction?(coordinates) if horizontal_move?(coordinates)
    fail ArgumentError, 'Invalid move'
  end

  def move_to!(coordinates)
    destination_piece = game.chess_pieces.find_by(position_x: coordinates.x, position_y: coordinates.y)

    if destination_piece
      fail ArgumentError, 'Invalid Move' if destination_piece.color == color
      destination_piece.destroy
    end
    update(position_x: coordinates.x, position_y: coordinates.y)
    game.update_current_player!
  end

  def opposite_color
    black? ? 'white' : 'black'
  end

  def coordinates
    Coordinates.new(position_x, position_y)
  end

  private

  def moved?
    updated_at != created_at
  end

  def x_start(destination_x)
    [position_x, destination_x].min + 1
  end

  def y_start(destination_y)
    [position_y, destination_y].min + 1
  end

  def x_end(destination_x)
    [position_x, destination_x].max
  end

  def y_end(destination_y)
    [position_y, destination_y].max
  end

  def diagonal_obstruction?(coordinates)
    from_x = x_start(coordinates.x)
    from_y = y_start(coordinates.y)
    to_x = x_end(coordinates.x)

    (from_x...to_x).each_with_index do |x, idx|
      return true if position_occupied?(Coordinates.new(x, from_y + idx))
    end

    false
  end

  def vertical_obstruction?(coordinates)
    from_y = y_start(coordinates.y)
    to_y = y_end(coordinates.y)

    (from_y...to_y).each do |y|
      return true if position_occupied?(Coordinates.new(coordinates.x, y))
    end

    false
  end

  def horizontal_obstruction?(coordinates)
    from_x = x_start(coordinates.x)
    to_x = x_end(coordinates.x)

    (from_x...to_x).each do |x|
      return true if position_occupied?(Coordinates.new(x, coordinates.y))
    end

    false
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
