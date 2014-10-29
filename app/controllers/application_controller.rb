class ApplicationController < ActionController::Base
  include ResourceExtensions
  include TraficExtensions
  include ResponseExtensions
  include DeviseExtensions
  include CustomsExtensions
  include ToggleExtensions

  respond_to :html
  protect_from_forgery with: :exception

  def is_admin?
    false
  end
end
