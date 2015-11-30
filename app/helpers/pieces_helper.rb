module PiecesHelper
  def draw_square_background(x_axis, y_axis)
    background_color = set_background_color(x_axis, y_axis) ? 'lite' : 'dark'

    content_tag :div, class: "chessboard__row__space chessboard__row__space--#{background_color}" do
      draw_square_content(x_axis, y_axis)
    end
  end

  def draw_square_content(x_axis, y_axis)
    current_piece = @chess_pieces.first

    if piece_should_be_drawn_on_square?(current_piece, x_axis, y_axis)
      @chess_pieces.shift
      piece_class = 'selected' if selected?(current_piece)
      piece_name = "#{current_piece.color.downcase}_#{current_piece.type.downcase}"
    else
      piece_name = 'empty_square'
    end

    link_to image_tag("#{piece_name}.png", id: current_piece.id, class: piece_class),
            piece_path(id: @selected_piece, position_x: x_axis, position_y: y_axis), method: 'PUT'
  end

  def set_background_color(x_axis, y_axis)
    x_axis.odd? && y_axis.odd? || x_axis.even? && y_axis.even?
  end

  def piece_should_be_drawn_on_square?(piece, x_axis, y_axis)
    piece && piece.position_x == x_axis && piece.position_y == y_axis
  end

  def selected?(current_piece)
    current_piece.id == @selected_piece.id
  end
end
