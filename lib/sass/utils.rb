require 'sass'
require 'sass/importer'

class SassUtils
  def self.compile (source)
    view_context = ActionView::Base.new
    assets = ActionView::Base::ASSET_PUBLIC_DIRECTORIES.values.map {|v| "app/assets/#{v}"}
    engine = Sass::Engine.new(source, {
      syntax: :sass,
      load_paths: Rails.application.assets.paths,
      style: :expanded,
      filesystem_importer: SassImporter,
      sprockets:  {
        context:     view_context,
        environment: assets
      }
    })
    engine.render
  end
end
