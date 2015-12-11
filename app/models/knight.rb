class Knight < ChessPiece
  VALID_MOVE_DISTANCES = [[1, 2], [2, 1]]

  def valid_move?(coordinates, skip_checkstate_check = false)
    return false if out_of_bounds?(coordinates)
    return false unless VALID_MOVE_DISTANCES.include? [diff_in_x(coordinates.x), diff_in_y(coordinates.y)]
    return true if skip_checkstate_check
    !(move_puts_king_in_check?(coordinates))
  end
end
