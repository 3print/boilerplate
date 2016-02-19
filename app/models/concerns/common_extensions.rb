module Concerns::CommonExtensions
  extend ActiveSupport::Concern

  included do
    extend Concerns::ToggleAttributes
    include Concerns::DashboardExtensions
    include Concerns::PunditExtensions
    include Concerns::Displayable
    include Concerns::ValidationState
  end
end
