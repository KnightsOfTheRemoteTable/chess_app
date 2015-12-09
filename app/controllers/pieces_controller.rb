class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_player

  def show
    @chess_pieces = current_game.chess_pieces.order(:position_y).order(:position_x).to_a
  end

  def update
    if moving_validly?
      @selected_piece.move_to!(Coordinates.new(move_to_x_parameter, move_to_y_parameter))
      render json: { success: true } && return if request.xhr?
      redirect_to game_path(@game)
    else
      render text: 'Forbidden', status: :unauthorized
    end
  end

  private

  def authorize_player
    render text: 'Forbidden', status: :unauthorized unless
      current_user == current_game.send("#{selected_piece.color}_player")
  end

  def current_game
    @game ||= ChessPiece.find(params[:id]).game
  end

  def selected_piece
    @selected_piece ||= ChessPiece.find(params[:id])
  end

  def moving_validly?
    selected_piece.valid_move?(Coordinates.new(move_to_x_parameter, move_to_y_parameter))
  end

  def move_to_x_parameter
    (params[:piece][:position_x]).to_i
  end

  def move_to_y_parameter
    (params[:piece][:position_y]).to_i
  end
end
