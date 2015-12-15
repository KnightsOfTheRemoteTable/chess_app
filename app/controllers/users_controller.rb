class UsersController < ApplicationController
  before_action :authenticate_user!

  def username
  end

  def show
    @user = User.find(params[:id])
    @wins = Game.where(winner: @user).count
  end

  def update
    current_user.update(user_params)
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:username)
  end
end
