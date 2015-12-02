class King < ChessPiece
  X_MOVE_FACTOR = 1
  Y_MOVE_FACTOR = 1

  BLACK_QUEENSIDE_CASTLE_TRAVERSED_SPACES = [Coordinates.new(3, 8), Coordinates.new(4, 8)]
  BLACK_KINGSIDE_CASTLE_TRAVERSED_SPACES  = [Coordinates.new(6, 8), Coordinates.new(7, 8)]
  WHITE_QUEENSIDE_CASTLE_TRAVERSED_SPACES = [Coordinates.new(3, 1), Coordinates.new(4, 1)]
  WHITE_KINGSIDE_CASTLE_TRAVERSED_SPACES  = [Coordinates.new(6, 1), Coordinates.new(7, 1)]

  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false if diff_in_x(coordinates.x) > X_MOVE_FACTOR
    return false if diff_in_y(coordinates.y) > Y_MOVE_FACTOR
    !obstructed?(coordinates)
  end

  def can_castle?(rook)
    return false if rook.moved?
    return false if moved?
    return false if obstructed?(rook.coordinates)

    side = selected_castle_side(rook)
    free_castling_spaces(side).each { |space| return false if king_capturable_at_space?(space) }

    true
  end

  private

  def selected_castle_side(rook)
    return :kingside  if rook.position_x == 8
    return :queenside if rook.position_x == 1
  end

  def free_castling_spaces(side)
    return BLACK_KINGSIDE_CASTLE_TRAVERSED_SPACES  if black_kingside?(side)
    return BLACK_QUEENSIDE_CASTLE_TRAVERSED_SPACES if black_queenside?(side)
    return WHITE_KINGSIDE_CASTLE_TRAVERSED_SPACES  if white_kingside?(side)
    return WHITE_QUEENSIDE_CASTLE_TRAVERSED_SPACES if white_queenside?(side)
  end

  def black_kingside?(side)
    black? && side == :kingside
  end

  def black_queenside?(side)
    black? && side == :queenside
  end

  def white_kingside?(side)
    white? && side == :kingside
  end

  def white_queenside?(side)
    white? && side == :queenside
  end

  def king_capturable_at_space?(coordinates)
    game.chess_pieces.with_color(opposite_color).find_each do |opponent|
      return true if opponent.valid_move?(coordinates)
    end
    false
  end
end
