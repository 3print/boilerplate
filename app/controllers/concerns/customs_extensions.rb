require 'active_support/concern'

module CustomsExtensions
  extend ActiveSupport::Concern

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def access_denied
    current_user ? forbidden : unauthorized
  end


  def forbidden
    redirect_to new_user_session_path, status: 403
  end

  def unauthorized
    redirect_to new_user_session_path
  end
end
