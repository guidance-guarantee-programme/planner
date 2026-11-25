module Qualtrics
  class Api
    def appointment_booked(json_payload)
      connection.post(
        'triggers?urlTokenId=9eb551c9-db38-4be5-9d65-dbedee004474',
        json_payload
      )
    end

    private

    def connection
      @connection ||= Faraday.new(connection_options) do |faraday|
        faraday.request  :json
        faraday.response :raise_error
        faraday.use      :instrumentation
        faraday.adapter  :http
      end
    end

    def connection_options
      {
        url: ENV.fetch('QUALTRICS_URI'),
        headers: {
          'X-API-TOKEN' => ENV.fetch('QUALTRICS_API_TOKEN')
        }
      }
    end
  end
end
