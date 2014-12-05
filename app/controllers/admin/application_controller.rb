class Admin::ApplicationController < ApplicationController
  layout 'admin'

  before_filter :reject_unauthorized_user!

  load_and_authorize_resource

  def controller_namespace
    [:admin]
  end

  def is_admin?
    true
  end
end
