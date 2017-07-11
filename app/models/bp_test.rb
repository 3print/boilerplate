# == Schema Information
#
# Table name: bp_tests
#
#  id            :integer          not null, primary key
#  image         :string(255)
#  pdf           :string(255)
#  int           :integer
#  json          :json
#  markdown      :text
#  text          :text
#  created_at    :datetime
#  updated_at    :datetime
#  enum          :integer
#  approved_at   :datetime
#  validated_at  :datetime
#  sequence      :integer
#  multiple_enum :integer          default([]), is an Array
#

class BpTest < ApplicationRecord
  include Concerns::HasSeo
  extend Concerns::Orderable

  mount_uploader :image, ImageUploader
  mount_uploader :pdf, PdfUploader

  enum enum: %i(foo bar baz), _prefix: true
  enum multiple_enum: %i(foo bar baz), _prefix: true, _multiple: true

  markdown_attr :markdown

  add_to_dashboard weight: 0, size: 2
  set_shared_policy PublicSourceModelPolicy

  validates :image, :int, :json, :markdown, :text, :enum, :validated_at, presence: true

  def caption
    "Test ##{id}"
  end

  attr_toggle :approve, off: :revocate
  attr_toggle :validate
end
