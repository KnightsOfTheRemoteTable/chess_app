class Queen < ChessPiece
  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false unless vertical_move?(coordinates) ||
                        horizontal_move?(coordinates) ||
                        diagonal_move?(coordinates)
    !obstructed?(coordinates)
  end
end
