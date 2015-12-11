class Rook < ChessPiece
  def valid_move?(coordinates, skip_checkstate_check = false)
    return false if out_of_bounds?(coordinates)
    return false unless horizontal_move?(coordinates) || vertical_move?(coordinates)
    return false if obstructed?(coordinates)
    return true if skip_checkstate_check
    !(move_puts_king_in_check?(coordinates))
  end
end
