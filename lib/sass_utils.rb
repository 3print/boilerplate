require 'sassc'
require 'sassc/importer'

class SassUtils
  def self.compile (source)
    view_context = ActionView::Base.new
    paths = Rails.env.development? ? Rails.application.assets.paths : Sprockets::Railtie.build_environment(Rails.application, true).paths
    engine = SassC::Engine.new(source, {
      syntax: :scss,
      load_paths: paths,
      # load_paths: view_context.assets.paths + [Compass::Frameworks['compass'].stylesheets_directory],
      style: :expanded,
      filesystem_importer: SassC::Importer,
      sprockets:  {
        context:     view_context,
        environment: paths
      }
    })
    engine.render
  end
end
