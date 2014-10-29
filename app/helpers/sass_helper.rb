
module SassHelper
  require 'sass'
  require 'tempfile'

  def inline_css(path)
    sassConvert = Sass::Engine.for_file("#{Rails.root}/app/assets/stylesheets/#{path}.sass", {})
    css = sassConvert.render
    "<style>#{css}</style>"
  end

  def compile(item)
    if item.is_a? Symbol
      txt = "+#{item}"
    elsif item.is_a? String
      txt = item
    elsif item.is_a? Hash
      txt = item.keys.inject([]){|mem, k| mem << "#{k.to_s.gsub('_', '-')}: #{item[k]}"; mem}.compact.join("; ")
    end
    sass = "@import partials/mail_common.sass\n\nfoo\n\t"
    sass << txt.gsub(/\s*;\s*/, "\n\t")
    sassConvert = Sass::Engine.new sass, load_paths: [
      "#{Rails.root}/app/assets/stylesheets/"
    ]
    sassConvert.render.gsub(/foo\s*\{\s*/, '').gsub(/\s*\}$/, '').gsub(/\s+/, ' ')
  end

  def styles *items
    items.map{|i| compile(i)}.join(';')
  end
end
