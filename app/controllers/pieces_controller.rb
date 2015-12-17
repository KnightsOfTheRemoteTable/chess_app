class PiecesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_player
  before_action :check_turn

  def show
    @chess_pieces = current_game.chess_pieces.order(:position_y).order(:position_x).to_a
  end

  def update
    attempt_move

    render(json: { success: moving_validly?, message: message }, status: http_status) && return if request.xhr?

    if moving_validly?
      redirect_to selected_piece.game
    else
      render text: message, status: http_status
    end
  end

  def valid_moves
    render json: selected_piece.valid_moves
  end

  private

  def authorize_player
    render text: 'Forbidden', status: :unauthorized unless
      current_user == current_game.send("#{selected_piece.color}_player")
  end

  def check_turn
    render text: 'Not your turn', status: :forbidden unless
      current_game.send("current_player_is_#{selected_piece.color}_player?")
  end

  def current_game
    @game ||= selected_piece.game
  end

  def selected_piece
    @selected_piece ||= ChessPiece.find(params[:id])
  end

  def http_status
    return :ok if moving_validly?
    :forbidden
  end

  def message
    return 'Success' if moving_validly?
    'Invalid move'
  end

  def attempt_move
    return unless moving_validly?
    selected_piece.move_to!(destination_coordinates)
    check_game_over
    Pusher.trigger("channel-#{current_game.id}", 'refresh_event', message: '') unless Rails.env.test?
  end

  def check_game_over
    return unless current_game.checkmate?
    current_game.update(winner: current_user)
    flash.notice = 'Game over. #{current_user.username} wins'
  end

  def moving_validly?
    @valid_move ||= selected_piece.valid_move?(destination_coordinates) &&
                    !(selected_piece.move_puts_king_in_check?(destination_coordinates))
  end

  def destination_coordinates
    @destination_coordinates ||= Coordinates.new(move_to_x_parameter, move_to_y_parameter)
  end

  def move_to_x_parameter
    (params[:piece][:position_x]).to_i
  end

  def move_to_y_parameter
    (params[:piece][:position_y]).to_i
  end
end
