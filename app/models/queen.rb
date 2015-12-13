class Queen < ChessPiece
  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false unless within_movement_parameters?(coordinates)
    return false if friendly_piece_at?(coordinates)
    !(obstructed?(coordinates))
  end

  def within_movement_parameters?(coordinates)
    vertical_move?(coordinates) || horizontal_move?(coordinates) || diagonal_move?(coordinates)
  end
end
