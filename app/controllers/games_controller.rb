class GamesController < ApplicationController
  def index
    @gamnes = Games.all
  end

  def new
    @game = Game.new
  end

  def create
  end

  def show
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:name)
  end
end
