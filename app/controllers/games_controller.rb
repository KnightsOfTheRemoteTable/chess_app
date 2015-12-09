class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_player, only: :forfeit

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params.merge(black_player: current_user))
    if @game.valid?
      flash[:notice] = 'Game created. You are the black player.'
      redirect_to games_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def show
    @chess_pieces = current_game.chess_pieces.order(:position_y).order(:position_x).to_a
  end

  def forfeit
    current_game.forfeit_by!(current_user)
    redirect_to current_game, alert: 'You have forfeited the game'
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

  def authorize_player
    render text: 'Forbidden', status: :unauthorized unless current_game.players.include?(current_user)
  end

  def current_game
    @game ||= Game.find(params[:id])
  end
end
