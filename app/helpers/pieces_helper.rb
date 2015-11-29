module PiecesHelper
  def draw_square_2(x_axis, y_axis)
    if x_axis.odd? && y_axis.odd? || x_axis.even? && y_axis.even?
      color = 'lite'
    else
      color = 'dark'
    end
    content_tag :div, class: "chessboard__row__space chessboard__row__space--#{color}" do
      draw_piece(x_axis, y_axis)
    end
  end

  def draw_piece_2(x_axis, y_axis)
    current_piece = @chess_pieces.first
    piece_class = ''
    if current_piece && current_piece.position_x == x_axis && current_piece.position_y == y_axis
      @chess_pieces.shift

      piece_class = 'selected' if current_piece.id == selected_piece.id
      piece_name = "#{current_piece.color.downcase}_#{current_piece.type.downcase}"
    else
      piece_name = 'empty_square'
    end
    link_to image_tag("#{piece_name}.png",
                      id: current_piece.id,
                      class: piece_class),
            piece_path(id: @selected_piece, position_x: x_axis, position_y: y_axis),
            method: 'PUT'
  end
end
