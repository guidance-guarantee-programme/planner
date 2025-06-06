require 'selenium/webdriver'

Capybara.register_driver :chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new(
    args: %w[
      headless
      no-sandbox
      disable-gpu
      disable-background-timer-throttling
      disable-renderer-backgrounding
      disable-backgrounding-occluded-windows
      window-size=1500,2500
    ]
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.w3c_click_offset = false
Capybara.default_normalize_ws = true
Capybara.default_max_wait_time = 10 if ENV['TRAVIS']
Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :chrome_headless
Capybara.raise_server_errors = false unless ENV['RAISE_SERVER_ERRORS']

Selenium::WebDriver.logger.level = :warn
