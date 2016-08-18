source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

gem 'audited-activerecord'
gem 'booking_locations'
gem 'gds-sso'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'rails', '4.2.7.1'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'govuk_admin_template'
gem 'plek'
gem 'puma'
gem 'foreman'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'bugsnag'
gem 'newrelic_rpm'
gem 'faraday'
gem 'faraday-conductivity'
gem 'faraday_middleware'

group :development, :test do
  gem 'capybara'
  gem 'pry-byebug'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'site_prism'
end

group :development do
  gem 'rubocop'
  gem 'web-console', '~> 2.0'
end

group :test do
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_12factor'
end
