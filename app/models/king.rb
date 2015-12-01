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

    free_castling_spaces.each { |space| return false if king_capturable_at_space?(space) }

    true
  end

  def free_castling_spaces
    black? ? BLACK_KINGSIDE_CASTLE_TRAVERSED_SPACES && BLACK_QUEENSIDE_CASTLE_TRAVERSED_SPACES :
             WHITE_KINGSIDE_CASTLE_TRAVERSED_SPACES && WHITE_QUEENSIDE_CASTLE_TRAVERSED_SPACES
  end

  def king_capturable_at_space?(coordinates)
    game.chess_pieces.with_color(opposite_color).find_each do |opponent|
      return true if opponent.valid_move?(coordinates)
    end
    false
  end
end
