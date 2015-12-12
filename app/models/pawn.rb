class Pawn < ChessPiece
  FIRST_MOVE_FACTOR = 2
  SECOND_MOVE_FACTOR = 1

  def valid_move?(coordinates, skip_checkstate_check = false)
    return false unless forward_move?(coordinates.y)
    return valid_vertical_move?(coordinates) if vertical_move?(coordinates)
    return true if game.can_en_passant?(coordinates)
    return false unless valid_capture?(coordinates)
    return true if skip_checkstate_check
    !(move_puts_king_in_check?(coordinates))
  end

  def move_to!(coordinates)
    two_step_move = diff_in_y(coordinates.y) == FIRST_MOVE_FACTOR
    capture_en_passant(coordinates) if game.can_en_passant?(coordinates)
    super
    game.update(en_passant_position: "#{coordinates.x},#{backward_one(coordinates.y)}") if two_step_move
  end

  private

  def capture_en_passant(coordinates)
    game.chess_pieces.find_by(
      position_x: coordinates.x,
      position_y: backward_one(coordinates.y)
    ).destroy
  end

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
    return true if game.can_en_passant?(coordinates)
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

  def backward_one(y)
    y + -forward_direction
  end

  def forward_direction
    white? ? 1 : -1
  end

  def moved?
    updated_at != created_at
  end

  def forward_move?(destination_y)
    y_distance = destination_y - position_y
    white? ? y_distance > 0 : y_distance < 0
  end
end
