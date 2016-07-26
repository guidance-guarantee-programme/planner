source 'https://rubygems.org'

ruby IO.read('.ruby-version').strip

gem 'booking_locations'
gem 'gds-sso'
gem 'rails', '4.2.6'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'govuk_admin_template'
gem 'puma'
gem 'foreman'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'bugsnag'

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

group :production do
  gem 'rails_12factor'
end
