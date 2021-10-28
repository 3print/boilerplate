class TwoFactorSettingsController < ApplicationController
  before_action :authenticate_user!
  layout 'devise'

  def new
    if current_user.otp_required_for_login
      flash[:alert] = '2fa.already_enabled'.t
      return redirect_to edit_user_registration_path
    end

    current_user.generate_two_factor_secret_if_missing!
  end

  def create
    unless current_user.valid_password?(enable_2fa_params[:password])
      flash.now[:alert] = '2fa.incorrect_password'.t
      return render :new
    end

    if current_user.validate_and_consume_otp!(enable_2fa_params[:code])
      current_user.enable_two_factor!

      flash[:notice] = '2fa.backup_codes'.t
      redirect_to edit_two_factor_settings_path
    else
      flash.now[:alert] = '2fa.incorrect_code'.t
      render :new
    end
  end

  def edit
    unless current_user.otp_required_for_login
      flash[:alert] = '2fa.activate_2fa_first'.t
      return redirect_to new_two_factor_settings_path
    end

    if current_user.two_factor_backup_codes_generated?
      flash[:alert] = 'backup_codes_seen'.t
      return redirect_to edit_user_registration_path
    end

    @backup_codes = current_user.generate_otp_backup_codes!
    current_user.save!
  end

  def destroy
    if current_user.disable_two_factor!
      flash[:notice] = '2fa.disabled'.t
      redirect_to edit_user_registration_path
    else
      flash[:alert] = '2fa.couldnt_disable'.t
      redirect_back fallback_location: root_path
    end
  end

  private

  def enable_2fa_params
    params.require(:two_fa).permit(:code, :password)
  end

end
