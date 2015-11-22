class Bishop < ChessPiece
  def valid_move?(destination_x, destination_y)
    return false unless diagonal_move?(destination_x, destination_y)
    !(obstructed?(destination_x, destination_y))
  end
end
