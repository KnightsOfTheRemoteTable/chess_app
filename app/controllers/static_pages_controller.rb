class StaticPagesController < ApplicationController
  def index
    @games = Game.all
  end
end
