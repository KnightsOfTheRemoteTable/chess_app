class King < ChessPiece
  X_MOVE_FACTOR = 1
  Y_MOVE_FACTOR = 1

  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false if diff_in_x(coordinates.x) > X_MOVE_FACTOR
    return false if diff_in_y(coordinates.y) > Y_MOVE_FACTOR
    !obstructed?(coordinates)
  end
end
