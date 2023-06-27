ruby IO.read('.ruby-version').strip

# force Bundler to use SSL
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# temporarily switch to this since Travis can't resolve the new certificate chain
source 'https://rails-assets.org' do
  gem 'rails-assets-bootstrap-daterangepicker'
  gem 'rails-assets-eonasdan-bootstrap-datetimepicker'
  gem 'rails-assets-fullcalendar', '3.9.0'
  gem 'rails-assets-fullcalendar-scheduler', '1.9.4'
  gem 'rails-assets-growl'
  gem 'rails-assets-pusher'
  gem 'rails-assets-qTip2'
end

source 'https://rubygems.org' do # rubocop:disable Metrics/BlockLength
  gem 'active_model_serializers'
  gem 'alertifyjs-rails'
  gem 'audited'
  gem 'azure-storage-blob'
  gem 'bh'
  gem 'booking_locations', github: 'guidance-guarantee-programme/booking_locations'
  gem 'bootstrap-kaminari-views'
  gem 'bugsnag'
  gem 'email_validator', '1.6.0'
  gem 'eventmachine', github: 'eventmachine/eventmachine'
  gem 'faraday'
  gem 'faraday-conductivity'
  gem 'faraday_middleware'
  gem 'font-awesome-rails'
  gem 'foreman'
  gem 'gds-sso'
  gem 'govuk_admin_template'
  gem 'kaminari'
  gem 'momentjs-rails'
  gem 'notifications-ruby-client'
  gem 'oj'
  gem 'pg'
  gem 'plek'
  gem 'postcodes_io'
  gem 'postgres-copy'
  gem 'princely'
  gem 'puma'
  gem 'pusher'
  gem 'rack-cors'
  gem 'rails', '~> 5.2.0'
  gem 'rails-observers'
  gem 'rgeo'
  gem 'rgeo-geojson'
  gem 'sassc-rails'
  gem 'select2-rails'
  gem 'sidekiq'
  gem 'sinatra', require: false
  gem 'sprockets', '3.7.2'
  gem 'sprockets-es6'
  gem 'uglifier', '>= 1.3.0'
  gem 'uk_postcode'
  gem 'working_hours'

  group :development, :test do
    gem 'bootsnap'
    gem 'capybara'
    gem 'factory_bot_rails'
    gem 'pry-byebug'
    gem 'pusher-fake'
    gem 'rspec-rails'
    gem 'site_prism'
  end

  group :development do
    gem 'rubocop', '~> 0.47.1', require: false
  end

  group :test do
    gem 'database_cleaner'
    gem 'launchy'
    gem 'phantomjs'
    gem 'poltergeist'
    gem 'selenium-webdriver'
    gem 'webdrivers'
    gem 'webmock'
  end

  group :staging, :production do
    gem 'lograge'
    gem 'rails_12factor'
    gem 'redis-rails', require: false
  end
end
