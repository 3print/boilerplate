module Concerns::PunditExtensions
  extend ActiveSupport::Concern

  included do
    def self.set_shared_policy(policy, &blk)
      *namespaces, class_name = self.name.split('::')
      namespace = namespaces.empty? ? Object : namespaces.join('::').constantize

      policy_class_name = "#{class_name}Policy"
      policy_class = Class.new(policy)

      namespace.const_set(policy_class_name, policy_class)
      policy_class.class_eval(&blk) if block_given?
    end
  end
end
