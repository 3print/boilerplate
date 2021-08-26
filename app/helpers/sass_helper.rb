
module SassHelper
  require 'sass_utils'
  require 'tempfile'

  def inline_css(path)
    source = File.read("#{Rails.root}/app/assets/stylesheets/#{path}.scss")
    "<style>#{SassUtils.compile(source)}</style>"
  end

  def compile(item)
    if item.is_a? Symbol
      txt = "@include #{item}();"
    elsif item.is_a? String
      txt = item
    elsif item.is_a? Hash
      txt = item.keys.inject([]){|mem, k| mem << "#{k.to_s.gsub('_', '-')}: #{item[k]}"; mem}.compact.join("; ")
    end
    sass = "@import 'partials/mail_common';foo { #{txt} }"
    SassUtils.compile(sass).gsub(/foo\s*\{\s*/, '').gsub(/\s*\}$/, '').gsub(/\s+/, ' ')
  end

  def styles *items
    items.map{|i| compile(i)}.join(';')
  end
end
