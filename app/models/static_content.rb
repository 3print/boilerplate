# == Schema Information
#
# Table name: static_contents
#
#  id         :bigint           not null, primary key
#  name       :string
#  key        :string
#  content    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StaticContent < ApplicationRecord
  set_shared_policy AdminPolicy
  has_one :seo_meta, as: :meta_owner

  accepts_nested_attributes_for :seo_meta

  column_display_type :content, :markdown

  validates :key, :name, :content, presence: true
end
