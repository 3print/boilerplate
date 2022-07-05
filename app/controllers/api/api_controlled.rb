class Api::ApiController < ActionController::API
  include ResourceExtensions
  include JsonTraficExtensions
  include Pundit
end
