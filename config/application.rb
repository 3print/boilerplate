require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Boilerplate
  ActiveSupport.halt_callback_chains_on_return_false = false

  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # Our default timezone
    config.time_zone = 'Paris'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr

    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.eager_load_paths << "#{config.root}/lib"
    config.autoload_paths << "#{config.root}/lib"

    config.active_record.raise_in_transactional_callbacks = true
    config.active_record.belongs_to_required_by_default = false

    config.exceptions_app = self.routes

    config.active_job.queue_adapter = :delayed_job
  end
end

if ENV["SLACK_WEBHOOK_URL"].present?
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :slack => {
      :webhook_url => ENV["SLACK_WEBHOOK_URL"],
      :channel => "#exceptions",
      :additional_parameters => {
        icon_url: "#{ENV["HOST"]}/assets/logo.png",
        mrkdwn: true,
        username: "Boilerplate-#{Rails.env}"
      }
    }
end
