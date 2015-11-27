module Concerns::Searchable
  extend ActiveSupport::Concern

  def self.extended(base)
    base.class_eval do
      has_one :search_index, as: :searchable
      scope :with_search, ->(q) do
        # As long as all the models haven't been updated we'll still use the
        # legacy search.
        return scoped unless q.present?
        q = q.parameterize
        joins("INNER JOIN search_indices ON search_indices.searchable_type = '#{name}' AND search_indices.searchable_id = #{table_name}.id")
        .where('search_indices.value ILIKE ?', "%#{q}%").uniq
      end

      def update_search_indices
        value = (search_by_columns || []).map do |column|
          self.send(column)
        end.select { |v| v.present? }.join(';')

        if value.present?
          search_index = self.search_index

          if search_index.nil?
            self.create_search_index value: value.parameterize, original_value: value, searchable_updated_at: self.updated_at
          elsif value != search_index.original_value
            search_index.original_value = value
            search_index.value = value.parameterize
            search_index.searchable_updated_at = self.updated_at
            search_index.save!
          end
        else
          self.search_index.try(:destroy)
        end
      end
    end
  end

  def normalize_params(q)
    q.is_a?(Hash) ? q.keys : q
  end

  def search_by(*columns)
    self.send(:define_method, :search_by_columns) do
      columns
    end

    after_save do
      update_search_indices
    end
  end

end
