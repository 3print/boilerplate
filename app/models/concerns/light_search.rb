module Concerns::LightSearch
  extend ActiveSupport::Concern

  def light_search_by(*columns)
    scope :with_text, -> (q) {
      if q.present?
        sql = columns.map {|c| "(#{translated c} ILIKE ?)" }.join(' OR ')
        args = [sql] + columns.map {|c| "%#{translate q}%" }
        where(*args)
      else
        all
      end
    }
  end

  def translate(word)
    word.gsub(/./){|k| TRANSLATION[k] || k}.downcase
  end

  def translated(field)
    "lower(translate(#{self.name.pluralize.underscore}.#{field},'#{TRANSLATION.keys.join}', '#{TRANSLATION.values.join}'))"
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
