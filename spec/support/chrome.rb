require 'selenium/webdriver'

# monkey patch https://github.com/teamcapybara/capybara/issues/2865
if Gem.loaded_specs.fetch('capybara').version == Gem::Version.new('3.40.0')
  Capybara::Selenium::Driver::ChromeDriver.prepend(Module.new do
    def reset!
      return unless @browser
      return super if chromedriver_version < 158

      standard_reset = Capybara::Selenium::Driver.instance_method(:reset!)
      switch_to_window(window_handles.first)
      window_handles.drop(1).each do |handle|
        within_given_window(handle) { standard_reset.bind_call(self) }
        close_window(handle)
      end
      standard_reset.bind_call(self)
    end
  end)
end

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
