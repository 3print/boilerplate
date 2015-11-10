module PunditExtensions
  extend ActiveSupport::Concern

  included do
    def self.set_shared_policy policy
      class_variable_set '@@shared_policy', policy
    end

    def self.shared_policy
      class_variable_get '@@shared_policy'
    end
  end

  def shared_policy
    self.class.shared_policy
  end
end
