class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_player, only: :forfeit

  def index
  end

  def new
  end

  def create
  end

  def show
    @game = Game.find(params[:id])
    @chess_pieces = @game.chess_pieces.order(:position_y).order(:position_x).to_a
  end

  def forfeit
    current_game.forfeit_by!(current_user)
    redirect_to current_game, alert: 'You have forfeited the game'
  end

  private

  def authorize_player
    render text: 'Forbidden', status: :unauthorized unless current_game.players.include?(current_user)
  end

  def current_game
    @game ||= Game.find(params[:id])
  end
end
