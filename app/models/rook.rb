class Rook < ChessPiece
  def valid_move?(destination_x, destination_y)
    # Non move
    return false if destination_x == position_x && destination_y == position_y

    # no obstruction
    return false if obstruction?(destination_x, destination_y) == true

    # horizontal or vertical move
    return false if (destination_x < position_x || destination_x > position_y) &&
                    (destination_y < position_y || destination_y > position_y)

    true
  end
end
