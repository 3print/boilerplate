module CommonExtensions
  extend ActiveSupport::Concern

  included do
    include ToggleAttributes
    include DashboardExtensions
    include PunditExtensions
    include Displayable
    include ValidationState
    include NamespaceExtensions
  end
end
