class King < ChessPiece
  X_MOVE_FACTOR = 1
  Y_MOVE_FACTOR = 1

  CASTLING_MOVE_DISTANCE = 2

  def valid_move?(coordinates)
    return false if out_of_bounds?(coordinates)
    return false unless move_within_limits?(coordinates)
    return false if friendly_piece_at?(coordinates)
    !(obstructed?(coordinates))
  end

  def can_castle?(rook)
    return false if rook.moved?
    return false if moved?
    return false if obstructed?(rook.coordinates)

    side = rook.kingside? ? :kingside : :queenside
    free_castling_spaces(side).each { |space| return false if capturable_at_space?(space) }

    true
  end

  def castle!(rook)
    return unless can_castle?(rook)

    return castle_kingside!(rook) if rook.kingside?
    castle_queenside!(rook)
  end

  def checkmate?
    return false unless game.check?
    return false if valid_move_available?
    return false if can_remove_check?
    true
  end

  private

  def move_within_limits?(coordinates)
    return false if diff_in_x(coordinates.x) > X_MOVE_FACTOR
    diff_in_y(coordinates.y) <= Y_MOVE_FACTOR
  end

  def path_of_check
    checking_piece = checking_pieces.first
    path = [checking_piece.coordinates]
    return path if checking_piece.is_a?(Knight)
    path + Move.new(piece: checking_piece, destination: coordinates).path
  end

  def can_remove_check?
    return false if checking_pieces.length > 1
    potential_squares = path_of_check

    game.chess_pieces.with_color(color).each do |piece|
      potential_squares.each do |position|
        return true if piece.valid_move?(position) && !piece.move_puts_king_in_check?(position)
      end
    end
    false
  end

  def checking_pieces
    @checking_pieces ||= game.chess_pieces.with_color(opposite_color).select do |opponent|
      opponent.valid_move?(coordinates)
    end
  end

  def valid_move_available?
    potential_moves.each do |position|
      return true if valid_move?(position) && !(move_puts_king_in_check?(position))
    end
    false
  end

  def potential_moves
    [-1, 0, 1].repeated_permutation(2)
      .reject { |offset| offset == [0, 0] }
      .map { |offset| Coordinates.new(position_x + offset[0], position_y + offset[1]) }
  end

  def free_castling_spaces(side)
    if side == :kingside
      destination_x = position_x + CASTLING_MOVE_DISTANCE
    else
      destination_x = position_x - CASTLING_MOVE_DISTANCE
    end
    Move.new(piece: self, destination: Coordinates.new(destination_x, position_y)).path + [coordinates]
  end

  def capturable_at_space?(coordinates)
    game.chess_pieces.with_color(opposite_color).find_each do |opponent|
      return true if opponent.valid_move?(coordinates)
    end

    false
  end

  def castle_kingside!(rook)
    move_to!(Coordinates.new(7, position_y))
    rook.move_to!(Coordinates.new(6, position_y))
  end

  def castle_queenside!(rook)
    move_to!(Coordinates.new(3, position_y))
    rook.move_to!(Coordinates.new(4, position_y))
  end
end
