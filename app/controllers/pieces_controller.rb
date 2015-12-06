class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_player

  def show
    @selected_piece = ChessPiece.find(params[:id])
    @game = @selected_piece.game
    @chess_pieces = @game.chess_pieces.order(:position_y).order(:position_x).to_a
  end

  def update
    @selected_piece = ChessPiece.find(params[:id])
    @game = @selected_piece.game

    if moving_validly?
      @selected_piece.move_to!(Coordinates.new(move_to_x_parameter, move_to_y_parameter))
      redirect_to game_path(@game)
    else
      render text: 'Forbidden', status: :unauthorized
    end
  end

  private

  def authorize_player
    if current_user == current_game.black_player
      render text: 'Forbidden', status: :unauthorized unless selected_piece.black?
    elsif current_user == current_game.white_player
      render text: 'Forbidden', status: :unauthorized unless selected_piece.white?
    end
  end

  def current_game
    @game ||= ChessPiece.find(params[:id]).game
  end

  def selected_piece
    @selected_piece ||= ChessPiece.find(params[:id])
  end

  def moving_validly?
    @selected_piece.valid_move?(Coordinates.new(move_to_x_parameter, move_to_y_parameter))
  end

  def move_to_x_parameter
    (params[:piece][:position_x]).to_i
  end

  def move_to_y_parameter
    (params[:piece][:position_y]).to_i
  end
end
