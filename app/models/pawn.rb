class Pawn < ChessPiece
  FIRST_MOVE_FACTOR = 2
  SECOND_MOVE_FACTOR = 1

  def valid_move?(coordinates)
    return false unless forward_move?(coordinates.y)
    return valid_vertical_move?(coordinates) if vertical_move?(coordinates)
    valid_capture?(coordinates)
  end

  private

  def valid_vertical_move?(coordinates)
    return false if moved_too_far?(coordinates.y)
    return false if position_occupied?(coordinates)
    !obstructed?(coordinates)
  end

  def moved_too_far?(destination_y)
    diff_in_y(destination_y) > y_move_factor
  end

  def valid_capture?(coordinates)
    return false unless single_diagonal_move?(coordinates)
    opponent_at?(coordinates)
  end

  def single_diagonal_move?(coordinates)
    diff_in_x(coordinates.x) == 1 && diff_in_y(coordinates.y) == 1
  end

  def opponent_at?(coordinates)
    destination_piece = game.chess_pieces.find_by(position_x: coordinates.x, position_y: coordinates.y)
    opponent?(destination_piece)
  end

  def opponent?(piece)
    !piece.nil? && piece.color != color
  end

  def y_move_factor
    moved? ? SECOND_MOVE_FACTOR : FIRST_MOVE_FACTOR
  end

  def moved?
    updated_at != created_at
  end

  def forward_move?(destination_y)
    y_distance = destination_y - position_y
    white? ? y_distance > 0 : y_distance < 0
  end
end
