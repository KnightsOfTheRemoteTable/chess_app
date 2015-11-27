class GamesController < ApplicationController
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
    @game = Game.find(params[:id])
    @game.forfeit_by!(current_user)
    redirect_to @game, alert: 'You have forfeited the game'
  end
end
