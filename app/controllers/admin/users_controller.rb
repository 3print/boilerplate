class Admin::UsersController < Admin::ApplicationController
  load_resource
  sort_resource by: 'last_name ASC'

  def index
    @users = @users.with_text params[:q] if params[:q].present?
    @users = @users.try(params[:r]) if params[:r].present?

    @users
  end

  def resource_params
    params.require(:user).permit(:first_name, :last_name, :email, :avatar, :role, :message, :remote_avatar_url, :password, :password_confirmation, :avatar_gravity)
  end
end
