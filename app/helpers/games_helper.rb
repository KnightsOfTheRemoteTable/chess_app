module GamesHelper
  def draw_square(x_axis, y_axis)
    current_piece = @chess_pieces.find_by(position_x: x_axis, position_y: y_axis)
    if x_axis.odd? && y_axis.odd? || x_axis.even? && y_axis.even?
      color = 'lite'
    else
      color = 'dark'
    end
    content_tag :div, class: "chessboard__row__space chessboard__row__space--#{color}" do
      if current_piece.present?
        if current_piece.type == 'Rook' && current_piece.color == 'white'
          image_tag 'light_rook.png'
        elsif current_piece.type == 'Rook' && current_piece.color == 'black'
          image_tag 'dark_rook.png'
        elsif current_piece.type == 'Bishop' && current_piece.color == 'white'
          image_tag 'light_bishop.png'
        elsif current_piece.type == 'Bishop' && current_piece.color == 'black'
          image_tag 'dark_bishop.png'
        elsif current_piece.type == 'Knight' && current_piece.color == 'white'
          image_tag 'light_knight.png'
        elsif current_piece.type == 'Knight' && current_piece.color == 'black'
          image_tag 'dark_knight.png'
        elsif current_piece.type == 'King' && current_piece.color == 'white'
          image_tag 'light_king.png'
        elsif current_piece.type == 'King' && current_piece.color == 'black'
          image_tag 'dark_king.png'
        elsif current_piece.type == 'Queen' && current_piece.color == 'white'
          image_tag 'light_queen.png'
        elsif current_piece.type == 'Queen' && current_piece.color == 'black'
          image_tag 'dark_queen.png'
        elsif current_piece.type == 'Pawn' && current_piece.color == 'white'
          image_tag 'light_pawn.png'
        elsif current_piece.type == 'Pawn' && current_piece.color == 'black'
          image_tag 'dark_pawn.png'
        end
      end
    end
  end
end
