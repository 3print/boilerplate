module Concerns::DashboardExtensions
  extend ActiveSupport::Concern

  included do
    def self.add_to_dashboard options={}
      Dashboard.add self, options
    end
  end
end
