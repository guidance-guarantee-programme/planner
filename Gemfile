source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

source 'https://rubygems.org' do
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
  gem 'newrelic_rpm'
  gem 'pg'
  gem 'plek'
  gem 'puma'
  gem 'rails', '5.0.1'
  gem 'rails-observers', github: 'rails/rails-observers', branch: 'master'
  gem 'sassc-rails'
  gem 'sidekiq'
  gem 'sinatra', '2.0.0.beta2', require: false
  gem 'sprockets-es6'
  gem 'uglifier', '>= 1.3.0'

  group :development, :test do
    gem 'capybara'
    gem 'factory_girl_rails'
    gem 'pry-byebug'
    gem 'rspec-rails'
    gem 'site_prism'
  end

  group :development do
    gem 'rubocop', require: false
  end

  group :test do
    gem 'coveralls', require: false
    gem 'database_cleaner'
    gem 'poltergeist'
    gem 'webmock'
  end

  group :staging, :production do
    gem 'rails_12factor'
  end
end
