class Rook < ChessPiece
  def valid_move?(destination_x, destination_y)
    # Non move
    return false if destination_x == self.position_x && destination_y == self.position_y

    # no obstruction
    return false if obstruction?(destination_x, destination_y) == true

    # horizontal or vertical move
    return false if (destination_x < self.position_x || destination_x > self.position_y) && ( destination_y < self.position_y || destination_y > self.position_y)

    return true
  end
end
