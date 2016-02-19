require 'active_support/concern'

module Concerns::NameInUrl
  extend ActiveSupport::Concern

  included do
    def self.as_param(key)
      before_validation do
        if self.permalink.nil? || self.permalink.empty?
          self.permalink = send(key).try(:parameterize)
        end
      end

      define_method :to_param do
        permalink
      end
    end
  end
end
