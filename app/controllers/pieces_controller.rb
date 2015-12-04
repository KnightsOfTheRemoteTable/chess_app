class PiecesController < ApplicationController
  def show
    @selected_piece = ChessPiece.find(params[:id])
    @game = @selected_piece.game
    @chess_pieces = @game.chess_pieces.order(:position_y).order(:position_x).to_a
  end

  def update
    @chess_piece = ChessPiece.find_by(params[:id])

  end
end
