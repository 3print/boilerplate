require 'sass'
require 'sass/importer'

class SassUtils
  def self.compile (source)
    engine = Sass::Engine.new(source, {
      syntax: :sass,
      load_paths: Rails.application.assets.paths,
      style: :expanded,
      filesystem_importer: SassImporter,
      sprockets:  {
        context:     Rails.application,
        environment: Rails.application.assets
      }
    })
    engine.render
  end
end
