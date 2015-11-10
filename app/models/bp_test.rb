class BpTest < ActiveRecord::Base
  extend Enumerize
  include CommonExtensions

  mount_uploader :image, ImageUploader
  mount_uploader :pdf, PdfUploader

  enumerize :enum, in: %i(foo bar baz)

  markdown_attr :markdown

  add_to_dashboard weight: 2
  set_shared_policy PublicModelPolicy

  def caption
    "Test ##{id}"
  end
end
