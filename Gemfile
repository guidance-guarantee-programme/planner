ruby IO.read('.ruby-version').strip

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-daterangepicker'
end

source 'https://rubygems.org' do # rubocop:disable Metrics/BlockLength
  gem 'audited'
  gem 'booking_locations'
  gem 'bootstrap-kaminari-views'
  gem 'bugsnag'
  gem 'email_validator'
  gem 'faraday'
  gem 'faraday-conductivity'
  gem 'faraday_middleware'
  gem 'foreman'
  gem 'gds-sso'
  gem 'govuk_admin_template',
      github: 'guidance-guarantee-programme/govuk_admin_template',
      branch: 'rails-deprecations'
  gem 'kaminari'
  gem 'momentjs-rails'
  gem 'newrelic_rpm'
  gem 'pg'
  gem 'plek'
  gem 'puma'
  gem 'rails', '5.1.1'
  gem 'rails-observers', github: 'rails/rails-observers', branch: 'master'
  gem 'sassc-rails'
  gem 'sidekiq'
  gem 'sinatra', require: false
  gem 'sprockets-es6'
  gem 'uglifier', '>= 1.3.0'

  group :development, :test do
    gem 'capybara'
    gem 'factory_girl_rails'
    gem 'phantomjs-binaries'
    gem 'pry-byebug'
    gem 'rspec-rails'
    gem 'site_prism'
  end

  group :development do
    gem 'rubocop', '~> 0.47.1', require: false
  end

  group :test do
    gem 'coveralls', require: false
    gem 'database_cleaner'
    gem 'poltergeist'
    gem 'webmock'
  end

  group :staging, :production do
    gem 'lograge'
    gem 'rails_12factor'
    gem 'redis-rails', require: false
  end
end
