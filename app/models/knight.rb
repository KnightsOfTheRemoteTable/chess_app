class Knight < ChessPiece
  XY_MOVE_FACTOR = 1
  ALT_XY_MOVE_FACTOR = 2

  def valid_move?(destination_x, destination_y)
    return false if out_of_bounds?(destination_x, destination_y)
    return false unless x_and_y_are_offset?(destination_x, destination_y)
    true
  end

  private

  def x_and_y_are_offset?(destination_x, destination_y)
    ((destination_x - position_x == XY_MOVE_FACTOR) && (destination_y - position_y == ALT_XY_MOVE_FACTOR)) ||
      ((destination_y - position_y == XY_MOVE_FACTOR) && (destination_x - position_x == ALT_XY_MOVE_FACTOR))
  end
end
