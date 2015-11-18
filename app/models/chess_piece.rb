# Chess piece model
class ChessPiece < ActiveRecord::Base
  belongs_to :player, class_name: 'User'
  belongs_to :game

  validates :type,
            :position_x,
            :position_y,
            :color,
            presence: true
  enum color: [:black, :white]

  def obstructed?(destination_x, destination_y)
    return diagonal_obstruction?(destination_x, destination_y) if diagonal_move?(destination_x, destination_y)
    return vertical_obstruction?(destination_x, destination_y) if vertical_move?(destination_x, destination_y)
    return horizontal_obstruction?(destination_x, destination_y) if horizontal_move?(destination_x, destination_y)
    fail ArgumentError, 'Invalid move'
  end

  private

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

  def diagonal_move?(destination_x, destination_y)
    x_diff = position_x - destination_x
    y_diff = position_y - destination_y

    x_diff.abs == y_diff.abs
  end
end
