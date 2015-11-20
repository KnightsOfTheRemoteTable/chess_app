class King < ChessPiece
  X_MOVE_FACTOR = 1
  Y_MOVE_FACTOR = 1

  def valid_move?(destination_x, destination_y)
    fail ArgumentError, 'Invalid Move' if obstructed?(destination_x, destination_y)
    exceeds_x_movement?(destination_x) || exceeds_y_movement?(destination_y) ? false : true
  end

  private

  def exceeds_x_movement?(destination_x)
    (destination_x - position_x).abs > X_MOVE_FACTOR
  end

  def exceeds_y_movement?(destination_y)
    (destination_y - position_y).abs > Y_MOVE_FACTOR
  end
end
