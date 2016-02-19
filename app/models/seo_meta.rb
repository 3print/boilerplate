# == Schema Information
#
# Table name: seo_meta
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  description     :text
#  meta_owner_id   :integer
#  meta_owner_type :string(255)
#  static_mode     :boolean
#  static_action   :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

class SeoMeta < ActiveRecord::Base
  include Concerns::CommonExtensions

  set_shared_policy PublicModelPolicy

  belongs_to :meta_owner, polymorphic: true

  scope :no_owner, ->() { where(meta_owner_id: nil) }
  scope :for_resource_index, ->(res) { no_owner.where(meta_owner_type: res) }
  scope :for_static_action, ->(a) { where(static_mode: true, static_action: a) }

  validates :meta_owner_type, presence: true, unless: 'static_mode'
  validates :static_action, presence: true, if: 'static_mode'

  def caption
    if meta_owner.present?
      meta_owner.to_s
    elsif static_mode
      "static.#{static_action}".t
    else
      meta_owner_type.present? ? (meta_owner_type == 'Home' ? 'root'.t : "models.#{meta_owner_type.underscore.pluralize}".t) : title
    end
  end
end
