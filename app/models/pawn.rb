class Pawn < ChessPiece
  FIRST_MOVE_FACTOR = 2
  SECOND_MOVE_FACTOR = 1

  def valid_move?(destination_x, destination_y)
    return false unless forward_move?(destination_y)
    return valid_vertical_move?(destination_x, destination_y) if vertical_move?(destination_x, destination_y)
    valid_capture?(destination_x, destination_y)
  end

  private

  def valid_vertical_move?(destination_x, destination_y)
    return false if moved_too_far?(destination_y)
    return false if position_occupied?(destination_x, destination_y)
    !obstructed?(destination_x, destination_y)
  end

  def moved_too_far?(destination_y)
    diff_in_y(destination_y) > y_move_factor
  end

  def valid_capture?(destination_x, destination_y)
    return false unless single_diagonal_move?(destination_x, destination_y)
    opponent_at?(destination_x, destination_y)
  end

  def single_diagonal_move?(destination_x, destination_y)
    diff_in_x(destination_x) == 1 && diff_in_y(destination_y) == 1
  end

  def opponent_at?(destination_x, destination_y)
    destination_piece = find_piece(destination_x, destination_y)
    opponent?(destination_piece)
  end

  def find_piece(destination_x, destination_y)
    game.chess_pieces.find_by(position_x: destination_x, position_y: destination_y)
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
    if color == 'white'
      y_distance > 0
    elsif color == 'black'
      y_distance < 0
    end
  end
end
