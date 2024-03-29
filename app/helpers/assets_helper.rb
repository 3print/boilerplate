
module AssetsHelper
  require 'sass_utils'

  def inline_file(path)
    if assets = Rails.application.assets
      asset = assets.find_asset(path)
      return '' unless asset
      asset.source
    else
      File.read(File.join(Rails.root, 'public', asset_path(path)))
    end
  end

  def inline_js(path)
    "<script>#{inline_file path}</script>".html_safe
  end

  def inline_css(path)
    "<style>#{inline_file path}</style>".html_safe
  end

  def compile(item)
    if item.is_a? Symbol
      txt = "@include #{item};"
    elsif item.is_a? String
      txt = item
    elsif item.is_a? Hash
      txt = item.keys.inject([]){|mem, k| mem << "#{k.to_s.gsub('_', '-')}: #{item[k]}"; mem}.compact.join("; ")
    end
    scss = "@import 'partials/mail_common';foo {#{txt}}"
    SassUtils.compile(scss).gsub(/foo\s*\{\s*/, '').gsub(/\s*\}$/, '').gsub(/\s+/, ' ')
  end

  def styles *items
    items.map{|i| compile(i)}.join(';')
  end
end
