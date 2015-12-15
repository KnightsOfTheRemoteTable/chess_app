class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_player, only: :forfeit

  def index
    @games = Game.where(winner: nil)
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
    @game = current_game
    @chess_pieces = current_game.chess_pieces.order(:position_y).order(:position_x).to_a
    flash[:alert] = 'The game is in a state of check' if current_game.check?
  end

  def join
    if current_game.white_player.nil? && current_user != current_game.black_player
      current_game.update(white_player: current_user)
      redirect_to current_game, notice: 'You are the white player.'
    else
      render text: 'This game is full or you are trying to play against yourself', status: :unauthorized
    end
  end

  def forfeit
    current_game.forfeit_by!(current_user)
    redirect_to games_path, alert: 'You have forfeited the game'
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
