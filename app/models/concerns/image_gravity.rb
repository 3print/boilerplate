require 'active_support/concern'

module Concerns::ImageGravity
  extend ActiveSupport::Concern

  def gravity_enum(*attrs)
    attrs.each do |key|
      enum "#{key}_gravity" => %w(north south east west north_west north_east south_west south_east center), _prefix: true
      after_save do
        gravity_changed_key = :"#{key}_gravity_changed?"
        changed_key = :"#{key}_changed?"

        if (respond_to?(gravity_changed_key) && send(gravity_changed_key)) ||
           (respond_to?(changed_key) && !send(changed_key)) && send(key).present?
          send(key).try(:recreate_versions!)
        end
      end
    end
  end
end
