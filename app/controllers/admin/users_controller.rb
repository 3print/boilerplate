class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # render view: 'users/show', locals: {user: my_user}
  end

  def create
    user_params = params[:user]

    user_params.permit(:first_name, :last_name)

    user = User.new user_params
  end
end
