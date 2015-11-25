class PiecesController < ApplicationController
  def show
    @piece = ChessPiece.find(params[:id])
    @game = @piece.game
    @chess_pieces = @game.chess_pieces.order(:position_y).order(:position_x).to_a
    render 'games/show'
  end
end
