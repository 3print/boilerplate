class RegistrationsController < Devise::RegistrationsController
  include DeviseExtensions

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def after_inactive_sign_up_path_for(resource)
    sign_out current_user
    flash[:notice] = 'messages.success.registered'.t
    root_path
  end

end
