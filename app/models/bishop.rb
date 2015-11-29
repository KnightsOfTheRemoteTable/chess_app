class Bishop < ChessPiece
  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false unless diagonal_move?(coordinates)
    !(obstructed?(coordinates))
  end
end
