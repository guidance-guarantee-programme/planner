require 'pusher-fake/support/base'

RSpec.configure do |config|
  config.after(:each, type: :feature) do
    PusherFake::Channel.reset
  end
end

RSpec.configure do |config|
  helpers = Module.new do
    def connect
      state = nil

      Timeout.timeout(5) do
        until state == 'connected'
          state = page.evaluate_script('Pusher.instance.connection.state')
        end
      end

      state
    end
  end

  config.include helpers, type: :feature
end
