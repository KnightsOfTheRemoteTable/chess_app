class Queen < ChessPiece
  def valid_move?(coordinates, skip_checkstate_check = false)
    return false if out_of_bounds?(coordinates)
    return false unless within_movement_parameters?(coordinates)
    return false if friendly_piece_at?(coordinates)
    return false if obstructed?(coordinates)
    return true if skip_checkstate_check
    !(move_puts_king_in_check?(coordinates))
  end

  def within_movement_parameters?(coordinates)
    vertical_move?(coordinates) || horizontal_move?(coordinates) || diagonal_move?(coordinates)
  end
end
