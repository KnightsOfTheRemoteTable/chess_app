module GamesHelper
  def draw_square(x_axis, y_axis)
    content_tag :div, class: "chessboard__row__space chessboard__row__space--#{background_color(x_axis, y_axis)}" do
      draw_piece(x_axis, y_axis)
    end
  end

  def draw_piece(x_axis, y_axis)
    current_piece = piece_for_square(x_axis, y_axis)

    return unless current_piece

    link_to image_tag("#{current_piece.color.downcase}_#{current_piece.type.downcase}.png"),
            piece_path(current_piece)
  end
end
