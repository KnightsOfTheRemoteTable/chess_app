class Rook < ChessPiece
  def valid_move?(destination_x, destination_y)
    return false if obstruction?(destination_x, destination_y)
    horizontal_move?(destination_x, destination_y) || vertical_move(destination_x, destination_y)
  end
end
