module Pundit
  class PolicyFinder
    def policy_with_fallback
      policy = policy_without_fallback
      policy ||= object.shared_policy if object.respond_to? :shared_policy
    end
    alias_method_chain :policy, :fallback
  end
end
