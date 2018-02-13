ruby IO.read('.ruby-version').strip

# force Bundler to use SSL
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-daterangepicker'
  gem 'rails-assets-fullcalendar'
  gem 'rails-assets-mailgun-validator-jquery', '0.0.3'
end

source 'https://rubygems.org' do # rubocop:disable Metrics/BlockLength
  gem 'active_model_serializers'
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
  gem 'govuk_admin_template'
  gem 'kaminari'
  gem 'momentjs-rails'
  gem 'newrelic_rpm'
  gem 'oj'
  gem 'pg'
  gem 'plek'
  gem 'puma'
  gem 'rails', '~> 5.1.2'
  gem 'rails-observers'
  gem 'sassc-rails'
  gem 'sidekiq'
  gem 'sinatra', require: false
  gem 'sprockets-es6'
  gem 'uglifier', '>= 1.3.0'
  gem 'uk_postcode'

  group :development, :test do
    gem 'bootsnap'
    gem 'capybara'
    gem 'factory_bot_rails'
    gem 'phantomjs'
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
