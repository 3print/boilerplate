source 'https://rubygems.org'
ruby '3.1.2'
gem 'rails', '~> 7'
gem 'puma', '>= 4.3.8'
gem 'settingslogic'
gem 'sendgrid'
gem "nokogiri", ">= 1.13.4"
gem "loofah", ">= 2.19.1"
gem "rails-html-sanitizer", ">= 1.4.4"

# Auth
gem 'devise'
gem 'devise-security'
gem 'devise-two-factor'
gem 'rqrcode'
gem "valid_email2"
gem 'devise-i18n'
gem 'pundit'
gem 'createsend'
gem 'authtrail'

# Database
gem 'pg'

# Views
gem 'haml-rails'
gem 'simple_form'
gem 'nested_form_fields'
gem 'enum_help'
gem 'redcarpet'

# Assets
gem 'sassc-rails'
gem 'uglifier'#, '>= 1.3.0'
gem 'coffee-rails'#, '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder'#, '~> 2.0'
gem 'bootstrap'
gem 'bourbon'
gem 'ejs'
gem 'jsbundling-rails'

# Models
gem 'kaminari'
gem 'verbs'

# Uploaders
gem 'rmagick', require: false
gem 'carrierwave'
gem 'carrierwave-aws'
gem 'faker'

# Delayed Job
gem 'delayed_job'
gem 'delayed_job_active_record'

# Notifier
gem 'exception_notification'
gem 'slack-notifier'
gem 'net-smtp' # to send email
gem 'net-imap' # for rspec
gem 'net-pop'  # for rspec

# Sumo custom tools
gem 'tprint-debug', git: 'https://github.com/3print/tprint-debug'
gem 'sumo_seed', git: 'https://github.com/3print/sumo_seed', branch: 'cn-rails-upgrade'

group :development do
  gem 'letter_opener'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'html2haml'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  # Guard
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'guard-spork'#, '1.5.1'
  gem 'guard-livereload'#, '1.0.3'

  gem 'rspec'#, '>=3.0'

  gem 'listen'#, '1.3.0'
  gem 'spork'#, '1.0.0rc3'

  gem 'annotate'

  gem "web-console"
  gem "rack-mini-profiler", "~> 2.0"

  gem 'spring', group: :development
  gem 'spring-watcher-listen', '~> 2.0.0'

end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'selenium-webdriver'
end

Dir["./*-gemfile.rb"].each do |f|
  eval File.read(f), nil, f
end
