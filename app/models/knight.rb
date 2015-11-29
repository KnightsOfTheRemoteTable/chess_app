class Knight < ChessPiece
  VALID_MOVE_DISTANCES = [[1, 2], [2, 1]]

  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    VALID_MOVE_DISTANCES.include? [diff_in_x(coordinates.x), diff_in_y(coordinates.y)]
  end
end
