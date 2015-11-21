class GamesController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
    @game = Game.find(params[:id])
    @chess_pieces = @game.chess_pieces.order(:position_y).order(:position_x)
  end
end
