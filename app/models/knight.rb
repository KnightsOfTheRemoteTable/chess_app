class Knight < ChessPiece
  VALID_MOVE_DISTANCES = [[1, 2], [2, 1]]

  def valid_move?(destination_x, destination_y)
    return false if out_of_bounds?(destination_x, destination_y)
    VALID_MOVE_DISTANCES.include? [diff_in_x(destination_x), diff_in_y(destination_y)]
  end
end
