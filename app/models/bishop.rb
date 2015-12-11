class Bishop < ChessPiece
  def valid_move?(coordinates, _skip_checkstate_check = false)
    return false if out_of_bounds?(coordinates)
    return false unless diagonal_move?(coordinates)
    !(obstructed?(coordinates))
  end
end
