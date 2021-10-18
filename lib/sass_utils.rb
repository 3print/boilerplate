require 'sassc'
require 'sassc/importer'

class SassUtils
  def self.compile(source)
    paths = Rails.env.development? ? Rails.application.assets.paths : Sprockets::Railtie.build_environment(Rails.application, true).paths
    engine = SassC::Engine.new(source, {
      syntax: :scss,
      load_paths: paths,
      style: :expanded,
      filesystem_importer: SassC::Importer,
    })
    engine.render
  end
end
