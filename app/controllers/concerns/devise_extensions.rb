require 'active_support/concern'

module DeviseExtensions
  extend ActiveSupport::Concern

  def after_sign_in_path_for(resource)
    if current_user.user?
      super
    else
      params[:redirect] if params[:redirect]
    end
  end

  def after_sign_up_path_for(resource)
    if current_user.user?
      super
    else
      admin_root_path
    end
  end
end
