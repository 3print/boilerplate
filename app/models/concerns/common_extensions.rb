module CommonExtensions
  extend ActiveSupport::Concern

  included do
    include DashboardExtensions
    include PunditExtensions
  end
end
