class BpTest < ActiveRecord::Base
  extend Enumerize

  mount_uploader :image, ImageUploader
  mount_uploader :pdf, PdfUploader

  enumerize :enum, in: %w(foo bar baz)

  col_type :markdown, :markdown
end
