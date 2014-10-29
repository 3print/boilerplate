class SessionsController < Devise::SessionsController
  include DeviseExtensions

  def sign_up_params
    params.require(:user).permit(:email, :password)
  end

end
