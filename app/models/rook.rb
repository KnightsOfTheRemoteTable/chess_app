class Rook < ChessPiece
  def valid_move?(coordinates, skip_checkstate_check = false)
    return false if out_of_bounds?(coordinates)
    return false unless move_within_limits?(coordinates)
    return false if friendly_piece_at?(coordinates)
    !(obstructed?(coordinates))
  end

  private

  def move_within_limits?(coordinates)
    horizontal_move?(coordinates) || vertical_move?(coordinates)
  end
end
