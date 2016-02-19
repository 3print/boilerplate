module Concerns::Displayable
  extend ActiveSupport::Concern

  included do
    def self.column_display_type col, type
      @column_display_types ||= {}
      @column_display_types[col.intern] = type
    end

    def self.get_column_display_type col
      @column_display_types ||= {}
      @column_display_types[col.intern]
    end

    def self.markdown_attr name
      column_display_type name, :markdown

      define_method :"#{name}_markdown" do
        ApplicationController.helpers.markdown(self.send(name))
      end
    end
  end

  def get_column_display_type col
    self.class.get_column_display_type col
  end

  def column_display_type col
    out = self.send(col)
    column = self.class.columns_hash[col.to_s]
    type = get_column_display_type col
    unless type
      type = column.present? ? column.type : :association
      type = :image if out.present? and out.is_a?(CarrierWave::Uploader::Base)
    end
    type
  end
end
