class Rook < ChessPiece
  INITIAL_KINGSIDE_X = 8

  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false unless move_within_limits?(coordinates)
    return false if friendly_piece_at?(coordinates)
    !(obstructed?(coordinates))
  end

  def kingside?
    position_x == INITIAL_KINGSIDE_X
  end

  private

  def move_within_limits?(coordinates)
    horizontal_move?(coordinates) || vertical_move?(coordinates)
  end
end
