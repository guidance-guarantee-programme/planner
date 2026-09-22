ruby IO.read('.ruby-version').strip

source 'https://rubygems.org'

# force Bundler to use SSL
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

source 'https://rubygems.org' do # rubocop:disable Metrics/BlockLength
  gem 'active_model_serializers'
  gem 'alertifyjs-rails'
  gem 'audited'
  gem 'azure-storage-blob'
  gem 'bh'
  gem 'booking_locations', github: 'guidance-guarantee-programme/booking_locations', ref: 'd8d22a7'
  gem 'bootstrap-kaminari-views'
  gem 'bugsnag'
  gem 'concurrent-ruby', '1.3.7'
  gem 'connection_pool', '~> 2.4.1'
  gem 'email_validator', '1.6.0'
  gem 'eventmachine', github: 'eventmachine/eventmachine'
  gem 'faraday'
  gem 'faraday-conductivity'
  gem 'faraday_middleware'
  gem 'font-awesome-rails'
  gem 'foreman'
  gem 'gds-sso', '~> 18.0'
  gem 'govuk_admin_template'
  gem 'kaminari'
  gem 'momentjs-rails'
  gem 'net-http'
  gem 'notifications-ruby-client'
  gem 'oj'
  gem 'pg'
  gem 'plek'
  gem 'postcodes_io'
  gem 'postgres-copy'
  gem 'princely'
  gem 'puma'
  gem 'pusher', '1.3.2'
  gem 'rack-cors'
  gem 'rails', '< 7.2'
  gem 'rails-observers'
  gem 'redis'
  gem 'rgeo'
  gem 'rgeo-geojson'
  gem 'sassc-rails'
  gem 'select2-rails'
  gem 'sidekiq', '~> 7'
  gem 'sinatra', require: false
  gem 'sprockets', '3.7.2'
  gem 'sprockets-es6'
  gem 'uglifier', '>= 1.3.0'
  gem 'uk_phone_numbers'
  gem 'uk_postcode'
  gem 'working_hours'

  group :development, :test do
    gem 'bootsnap'
    gem 'capybara'
    gem 'factory_bot_rails'
    gem 'pry-byebug'
    gem 'pusher-fake', '4.2.0'
    gem 'rspec-rails'
    gem 'rspec-retry'
    gem 'site_prism'
  end

  group :development do
    gem 'rubocop', require: false
    gem 'rubocop-rails', require: false
  end

  group :test do
    gem 'database_rewinder'
    gem 'launchy'
    gem 'selenium-webdriver'
    gem 'webmock'
  end

  group :staging, :production do
    gem 'aws-sdk-s3', require: false
    gem 'lograge'
    gem 'rails_12factor'
  end
end
