class King < ChessPiece
  X_MOVE_FACTOR = 1
  Y_MOVE_FACTOR = 1

  def valid_move?(destination_x, destination_y)
    return false if out_of_bounds?(destination_x, destination_y)
    return false if diff_in_x(destination_x) > X_MOVE_FACTOR
    return false if diff_in_y(destination_y) > Y_MOVE_FACTOR
    !obstructed?(destination_x, destination_y)
  end
end
