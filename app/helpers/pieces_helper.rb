module PiecesHelper
  def draw_square_background(x_axis, y_axis)
    current_piece = piece_for_square(x_axis, y_axis)
    link_to piece_path(id: @selected_piece, piece: { position_x: x_axis, position_y: y_axis }),
            method: 'PUT',
            class: "#{'selected' if selected?(current_piece)}" do
      content_tag :div, class: "chessboard__row__space chessboard__row__space--#{background_color(x_axis, y_axis)}" do
        draw_square_content(current_piece)
      end
    end
  end

  def draw_square_content(current_piece)
    return unless current_piece
    piece_name = "#{current_piece.color.downcase}_#{current_piece.type.downcase}"
    image_tag("#{piece_name}.png")
  end

  def background_color(x_axis, y_axis)
    if x_axis.odd? && y_axis.odd? || x_axis.even? && y_axis.even?
      'lite'
    else
      'dark'
    end
  end

  def piece_for_square(x_axis, y_axis)
    piece = @chess_pieces.first
    return @chess_pieces.shift if piece && piece.position_x == x_axis && piece.position_y == y_axis
  end

  def piece_should_be_drawn_on_square?(piece, x_axis, y_axis)
    piece && piece.position_x == x_axis && piece.position_y == y_axis
  end

  def selected?(current_piece)
    current_piece == @selected_piece
  end
end
