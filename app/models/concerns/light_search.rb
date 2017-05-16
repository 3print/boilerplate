module Concerns::LightSearch

  def light_search_by(*columns, &block)
    scope :with_text, -> (q) {
      if q.present?
        sql = columns.map {|c| "(#{translated c} ILIKE ?)" }.join(' OR ')
        args = [sql] + columns.map {|c| "%#{translate q}%" }
        base_scope = block_given? ? block.() : all
        base_scope.where(*args)
      else
        all
      end
    }
  end

  def translate(word)
    word.gsub(/./){|k| TRANSLATION[k] || k}.downcase
  end

  def translated(field)
    table_name = field.to_s.split('.').size > 1 ? nil : self.table_name
    "lower(translate(#{[table_name, field].compact.join('.')},'#{TRANSLATION.keys.join}', '#{TRANSLATION.values.join}'))"
  end

  TRANSLATION = {
    'ç' => 'c',
    'é' => 'e',
    'è' => 'e',
    'ê' => 'e',
    'à' => 'a',
    'î' => 'i',
    'ï' => 'i',
    # Must be at the end so that the character index is still coherent
    '-' => ' ',
    '/' => ' ',
    ',' => '',
    '.' => '',
    ':' => '',
  }
end
