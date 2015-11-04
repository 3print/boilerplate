class BpTest < ActiveRecord::Base
  extend Enumerize

  mount_uploader :image, ImageUploader
  mount_uploader :pdf, PdfUploader

  enumerize :enum, in: %i(foo bar baz)

  markdown_attr :markdown

  def caption
    "Test ##{id}"
  end
end
