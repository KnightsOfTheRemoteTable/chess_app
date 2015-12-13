class King < ChessPiece
  X_MOVE_FACTOR = 1
  Y_MOVE_FACTOR = 1

  BLACK_QUEENSIDE_CASTLE_TRAVERSED_SPACES = [Coordinates.new(3, 8), Coordinates.new(4, 8)]
  BLACK_KINGSIDE_CASTLE_TRAVERSED_SPACES  = [Coordinates.new(6, 8), Coordinates.new(7, 8)]
  WHITE_QUEENSIDE_CASTLE_TRAVERSED_SPACES = [Coordinates.new(3, 1), Coordinates.new(4, 1)]
  WHITE_KINGSIDE_CASTLE_TRAVERSED_SPACES  = [Coordinates.new(6, 1), Coordinates.new(7, 1)]

  CASTLING_KINGSIDE  = 8
  CASTLING_QUEENSIDE = 1

  def valid_move?(coordinates, _skip_checkstate_check = false)
    return false if out_of_bounds?(coordinates)
    return false unless move_within_limits?(coordinates)
    return false if friendly_piece_at?(coordinates)
    !(obstructed?(coordinates))
  end

  def can_castle?(rook)
    return false if rook.moved?
    return false if moved?
    return false if obstructed?(rook.coordinates)

    side = selected_castle_side(rook)
    free_castling_spaces(side).each { |space| return false if king_capturable_at_space?(space) }

    true
  end

  def castle!(rook)
    black_castle_kingside!  if black_king_can_castle_kingside?(rook)
    black_castle_queenside! if black_king_can_castle_queenside?(rook)
    white_castle_kingside!  if white_king_can_castle_kingside?(rook)
    white_castle_queenside! if white_king_can_castle_queenside?(rook)
  end

  private

  def move_within_limits?(coordinates)
    return false if diff_in_x(coordinates.x) > X_MOVE_FACTOR
    diff_in_y(coordinates.y) <= Y_MOVE_FACTOR
  end

  def black_king_can_castle_kingside?(rook)
    side = selected_castle_side(rook)
    black_kingside?(side) && can_castle?(rook)
  end

  def black_king_can_castle_queenside?(rook)
    side = selected_castle_side(rook)
    black_queenside?(side) && can_castle?(rook)
  end

  def white_king_can_castle_kingside?(rook)
    side = selected_castle_side(rook)
    white_kingside?(side) && can_castle?(rook)
  end

  def white_king_can_castle_queenside?(rook)
    side = selected_castle_side(rook)
    white_queenside?(side) && can_castle?(rook)
  end

  def selected_castle_side(rook)
    return :kingside  if rook.position_x == CASTLING_KINGSIDE
    return :queenside if rook.position_x == CASTLING_QUEENSIDE
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

  def black_castle_kingside!
    move_to!(Coordinates.new(7, 8))
    black_kingside_rook = game.chess_pieces.find_by(position_x: 8, position_y: 8)
    black_kingside_rook.move_to!(Coordinates.new(6, 8))
  end

  def black_castle_queenside!
    move_to!(Coordinates.new(3, 8))
    black_queenside_rook = game.chess_pieces.find_by(position_x: 1, position_y: 8)
    black_queenside_rook.move_to!(Coordinates.new(4, 8))
  end

  def white_castle_kingside!
    move_to!(Coordinates.new(7, 1))
    white_kingside_rook = game.chess_pieces.find_by(position_x: 8, position_y: 1)
    white_kingside_rook.move_to!(Coordinates.new(6, 1))
  end

  def white_castle_queenside!
    move_to!(Coordinates.new(3, 1))
    white_queenside_rook = game.chess_pieces.find_by(position_x: 1, position_y: 1)
    white_queenside_rook.move_to!(Coordinates.new(4, 1))
  end
end
