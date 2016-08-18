require 'faraday'
require 'faraday/conductivity'

class StatisticsWebHook
  def initialize(hook_uri = ENV.fetch('STATISTICS_WEB_HOOK_URI'))
    @hook_uri = hook_uri
  end

  def call(json_payload)
    connection.post do |request|
      request.body = json_payload
    end
  end

  private

  def connection
    @connection ||= Faraday.new(connection_options) do |faraday|
      faraday.request  :json
      faraday.response :raise_error
      faraday.use      :instrumentation
      faraday.adapter  Faraday.default_adapter
    end
  end

  def connection_options
    {
      url: hook_uri,
      request: {
        timeout:      Integer(ENV.fetch('STATISTICS_WEB_HOOK_TIMEOUT', 2)),
        open_timeout: Integer(ENV.fetch('STATISTICS_WEB_HOOK_OPEN_TIMEOUT', 2))
      }
    }
  end

  attr_reader :hook_uri
end
