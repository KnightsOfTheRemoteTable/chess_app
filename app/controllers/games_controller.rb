class GamesController < ApplicationController
  def index
    @gamnes = Games.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.'}
        format.json { render :show, :status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.erros, status: :unprocessable_entity }
      end
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
