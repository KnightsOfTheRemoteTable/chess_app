class PiecesController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def show
    @selected_piece = ChessPiece.find(params[:id])
    @game = @selected_piece.game
    @chess_pieces = @game.chess_pieces.order(:position_y).order(:position_x).to_a
  end

  def update
    @selected_piece = ChessPiece.find(params[:id])
    @game = @selected_piece.game

    if @selected_piece && @selected_piece.valid_move?(Coordinates.new(move_to_x_parameter, move_to_y_parameter))
      @selected_piece.move_to!(Coordinates.new(move_to_x_parameter, move_to_y_parameter))
      redirect_to game_path(@game) and return
    else
      render text: 'Invalid', status: :forbidden
    end
  end

  private

  def move_to_x_parameter
    (params[:piece][:position_x]).to_i
  end

  def move_to_y_parameter
    (params[:piece][:position_y]).to_i
  end
end
