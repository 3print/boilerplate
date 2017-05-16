module Concerns::CommonExtensions
  extend ActiveSupport::Concern

  included do
    include Concerns::ToggleAttributes
    include Concerns::DashboardExtensions
    include Concerns::PunditExtensions
    include Concerns::Displayable
    include Concerns::ValidationState
    include Concerns::NamespaceExtensions
  end
end
