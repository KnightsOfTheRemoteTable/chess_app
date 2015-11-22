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
    ((diff_in_x(destination_x) == XY_MOVE_FACTOR) && (diff_in_y(destination_y) == ALT_XY_MOVE_FACTOR)) ||
      ((diff_in_y(destination_y) == XY_MOVE_FACTOR) && (diff_in_x(destination_x) == ALT_XY_MOVE_FACTOR))
  end

  def diff_in_x(destination_x)
    (destination_x - position_x).abs
  end

  def diff_in_y(destination_y)
    (destination_y - position_y).abs
  end
end
