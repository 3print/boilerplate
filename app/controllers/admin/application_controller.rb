class Admin::ApplicationController < ApplicationController
  if Rails.env.dev?
    after_action :verify_authorized, :except => :index
    after_action :verify_policy_scoped, :only => :index
  end

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
