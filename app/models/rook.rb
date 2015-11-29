class Rook < ChessPiece
  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false unless horizontal_move?(coordinates) || vertical_move?(coordinates)
    !(obstructed?(coordinates))
  end
end
