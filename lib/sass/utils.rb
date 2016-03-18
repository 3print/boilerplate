require 'sass'
require 'sass/importer'

class SassUtils
  def self.compile (source)
    view_context = ActionView::Base.new
    engine = Sass::Engine.new(source, {
      syntax: :sass,
      load_paths: view_context.assets.paths + [Compass::Frameworks['compass'].stylesheets_directory],
      style: :expanded,
      filesystem_importer: SassImporter,
      sprockets:  {
        context:     view_context,
        environment: view_context.assets
      }
    })
    engine.render
  end
end
