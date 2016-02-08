require 'active_support/concern'

module ImageGravity
  extend ActiveSupport::Concern

  def gravity_enum(*attrs)
    attrs.each do |key|
      enum :"#{key}_gravity" => [
        "#{key}_north",
        "#{key}_south",
        "#{key}_east",
        "#{key}_west",
        "#{key}_north_west",
        "#{key}_north_east",
        "#{key}_south_west",
        "#{key}_south_east",
        "#{key}_center",
      ]
      after_save do
        gravity_changed_key = :"#{key}_gravity_changed?"
        changed_key = :"#{key}_changed?"

        if (respond_to?(gravity_changed_key) && send(gravity_changed_key)) &&
           (respond_to?(changed_key) && !send(changed_key))
          send(key).recreate_versions!
        end
      end
    end
  end
end
