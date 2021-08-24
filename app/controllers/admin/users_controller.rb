class Admin::UsersController < Admin::ApplicationController
  load_resource
  sort_resource by: 'last_name ASC'

  def index
    @resource = @resource.with_text params[:q] if params[:q].present?
    @resource = @resource.try(params[:r]) if params[:r].present?
  end

  def resource_params
    user_params = params.require(:user).permit(:first_name, :last_name, :email, :avatar, :role, :message, :remote_avatar_url, :password, :password_confirmation, :avatar_gravity)

    user_params.delete(:password) if user_params[:password].blank?
    user_params.delete(:password_confirmation) if user_params[:password_confirmation].blank?
    user_params
  end
end
