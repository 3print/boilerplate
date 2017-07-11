source 'https://rubygems.org'
ruby '2.3.4'
gem 'rails', '~> 5.0'
gem 'spring',        group: :development
gem 'unicorn'
gem 'unicorn-rails'
gem 'settingslogic'
gem 'sendgrid'
gem 'sdoc', '~> 0.4.0',          group: :doc

# Auth
gem 'devise'
gem 'devise-i18n'
gem 'devise_masquerade'
gem 'pundit'
gem 'createsend'
gem 'pwdcalc'

# Database
gem 'pg'

# Views
gem 'haml-rails'
gem 'simple_form'
gem 'nested_form'
gem 'enum_help'
gem 'redcarpet'

# Assets
gem 'sassc-rails'
gem 'uglifier'#, '>= 1.3.0'
gem 'coffee-rails'#, '~> 4.0.0'
gem 'jquery-rails'
gem 'jbuilder'#, '~> 2.0'
gem 'bootstrap-sass'
gem 'bourbon'
gem 'eco'

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

# Sumo custom tools
gem 'tprint-debug', git: 'https://github.com/3print/tprint-debug'
gem 'sumo_seed', git: 'https://github.com/3print/sumo_seed'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri_22, :mri_23, :rbx]
  gem 'html2haml'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
  gem 'rsense'
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
end
group :development, :test do
  gem 'factory_girl_rails'
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
