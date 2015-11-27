class Rook < ChessPiece
  def valid_move?(destination_x, destination_y)
    return false if out_of_bounds?(destination_x, destination_y)
    return false if diagonal_move?(destination_x, destination_y)
    return false unless horizontal_move?(destination_x, destination_y) || vertical_move?(destination_x, destination_y)
    !(obstructed?(destination_x, destination_y))
  end
end
