class UsersController < ApplicationController
  before_action :authenticate_user!

  def username
  end

  def show
    @user = User.find(params[:id])
    render json: @user.profile_data
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
