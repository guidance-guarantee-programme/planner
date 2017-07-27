require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    phantomjs: Phantomjs.path
  )
end

Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 20
