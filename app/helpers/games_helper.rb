module GamesHelper
  def draw_square(x_axis, y_axis)
    if x_axis.odd? && y_axis.odd? || x_axis.even? && y_axis.even?
      color = 'lite'
    else
      color = 'dark'
    end
    content_tag :div, class: "chessboard__row__space chessboard__row__space--#{color}" do
      draw_piece(x_axis, y_axis)
    end
  end

  def draw_piece(x_axis, y_axis)
    current_piece = @chess_pieces.first
    return unless current_piece && current_piece.position_x == x_axis && current_piece.position_y == y_axis
    @chess_pieces.shift
    link_to image_tag("#{current_piece.color.downcase}_#{current_piece.type.downcase}.png"), piece_path(current_piece)
  end
end
