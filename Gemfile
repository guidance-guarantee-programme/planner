source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

gem 'audited'
gem 'rails-observers', github: 'rails/rails-observers', branch: 'master'
gem 'booking_locations'
gem 'gds-sso'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'rails', '5.0.0.1'
gem 'pg'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'govuk_admin_template'
gem 'plek'
gem 'puma'
gem 'foreman'
gem 'sidekiq'
gem 'sinatra', '2.0.0.beta2', require: false
gem 'bugsnag'
gem 'newrelic_rpm'
gem 'faraday'
gem 'faraday-conductivity'
gem 'faraday_middleware'
gem 'sprockets-es6'

group :development, :test do
  gem 'capybara'
  gem 'pry-byebug'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'site_prism'
end

group :development do
  gem 'rubocop', require: false
end

group :test do
  gem 'coveralls', require: false
  gem 'database_cleaner'
  gem 'webmock'
  gem 'poltergeist'
  gem 'phantomjs-binaries'
end

group :staging, :production do
  gem 'rails_12factor'
end
