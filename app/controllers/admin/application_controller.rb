class Admin::ApplicationController < ApplicationController
  include Pundit
  layout 'admin'

  before_filter :reject_unauthorized_user!

  rescue_from Pundit::NotAuthorizedError, with: :access_denied

  def controller_namespace
    [:admin]
  end

  def is_admin?
    true
  end

  def reject_unauthorized_user!
    unauthorized unless current_user.present? && current_user.admin?
  end

end
