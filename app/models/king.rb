class King < ChessPiece
  X_MOVE_FACTOR = 1
  Y_MOVE_FACTOR = 1

  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false if diff_in_x(coordinates.x) > X_MOVE_FACTOR
    return false if diff_in_y(coordinates.y) > Y_MOVE_FACTOR
    !obstructed?(coordinates)
  end

  def can_castle?(rook)
    return false if obstructed?(Coordinates.new(rook.position_x, rook.position_y))
    return false if rook.moved?
    return false if moved?
  end
end
