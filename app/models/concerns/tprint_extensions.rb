module TprintExtensions
  extend ActiveSupport::Concern

  included do
    def self.col_type col, type
      @col_types ||= {}
      @col_types[col.intern] = type
    end

    def self.get_col_type col
      @col_types ||= {}
      @col_types[col.intern]
    end
  end

  def get_col_type col
    self.class.get_col_type col
  end

  def col_type col
    out = self.send(col)
    column = self.class.columns_hash[col.to_s]
    type = get_col_type col
    unless type
      type = column.present? ? column.type : :association
      type = :image if out.present? and out.is_a?(CarrierWave::Uploader::Base)
    end
    type
  end
end
