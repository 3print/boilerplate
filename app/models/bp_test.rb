class BpTest < ActiveRecord::Base
  extend Enumerize

  mount_uploader :image, ImageUploader
  mount_uploader :pdf, PdfUploader

  enumerize :enum, in: %i(foo bar baz)

  markdown_attr :markdown

  add_to_dashboard weight: 2

  def caption
    "Test ##{id}"
  end
end
