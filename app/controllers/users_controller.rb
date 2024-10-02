class UsersController < ApplicationController
  def show
    @user = User.find_by!(username: params.fetch(:username))
  end

  def user_params
    params.require(:user).permit(:avatar)
  end
end
