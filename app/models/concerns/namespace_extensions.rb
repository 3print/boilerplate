module Concerns::NamespaceExtensions
  extend ActiveSupport::Concern

  included do
    def self.namespaced_name
      self.table_name.singularize
    end
  end
end
