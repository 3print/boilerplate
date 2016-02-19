require 'active_support/concern'

module Concerns::HasSeo
  extend ActiveSupport::Concern

  def self.included(base = nil, &block)
    if base.present?
      consumers = if instance_variable_defined?("@_consumers")
        instance_variable_get("@_consumers")
      else
        instance_variable_set("@_consumers", [])
      end

      consumers << base
    end

    super
  end

  included do
    has_one :seo_meta, as: :meta_owner, dependent: :destroy
    accepts_nested_attributes_for :seo_meta, allow_destroy: true

    class << self
      def seo_meta
        SeoMeta.where(meta_owner_type: self.name, meta_owner_id: nil).first
      end
    end
  end
end
