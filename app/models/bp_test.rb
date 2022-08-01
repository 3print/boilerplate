# == Schema Information
#
# Table name: bp_tests
#
#  id             :integer          not null, primary key
#  image          :string
#  pdf            :string
#  int            :integer
#  json           :json
#  markdown       :text
#  text           :text
#  created_at     :datetime
#  updated_at     :datetime
#  enum           :integer
#  approved_at    :datetime
#  validated_at   :datetime
#  sequence       :integer
#  image_gravity  :integer
#  image_alt_text :string
#  visual         :string
#  visual_regions :json
#

class BpTest < ApplicationRecord
  include HasSeo
  extend Orderable
  extend ImageGravity
  include ImageVersions

  mount_uploader :image, ImageUploader
  mount_uploader :visual, ImageUploader
  mount_uploader :pdf, PdfUploader

  enum :enum, %i(foo bar baz), prefix: true

  markdown_attr :markdown

  gravity_enum :image
  expose_versions_for :visual, {
    thumb: [60, 60],
  }

  add_to_dashboard weight: 0, size: 2
  set_shared_policy PublicSourceModelPolicy

  validates :image, :int, :json, :markdown, :text, :enum, presence: true

  def caption
    "Test ##{id}"
  end

  attr_toggle :approve, off: :revocate
  attr_toggle :validate, off: :invalidate
end
