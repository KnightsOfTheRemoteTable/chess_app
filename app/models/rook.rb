class Rook < ChessPiece
  def valid_move?(destination_x, destination_y)
    return false if destination_matches_origin(destination_x, destination_y)
    return false if obstruction?(destination_x, destination_y)
    horizontal_move?(destination_x, destination_y) || vertical_move(destination_x, destination_y)
  end

  def destination_matches_origin(destination_x, destination_y)
    destination_x == position_x && destination_y == position_y
  end
end
