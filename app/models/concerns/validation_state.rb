module Concerns::ValidationState
  extend ActiveSupport::Concern

  included do
    self.after_validation do
      @validated = true
    end
  end

  def was_validated?
    @validated
  end
end
