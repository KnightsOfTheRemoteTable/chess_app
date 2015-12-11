class Bishop < ChessPiece
  def valid_move?(coordinates, skip_checkstate_check = false)
    return false if out_of_bounds?(coordinates)
    return false unless diagonal_move?(coordinates)
    return false if obstructed?(coordinates)
    return true if skip_checkstate_check
    !(move_puts_king_in_check?(coordinates))
  end
end
