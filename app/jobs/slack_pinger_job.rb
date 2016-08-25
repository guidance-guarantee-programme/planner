class SlackPingerJob < ActiveJob::Base
  queue_as :default

  def perform(booking_request)
    return unless hook_uri

    booking_location = BookingLocations.find(booking_request.location_id)
    hook = StatisticsWebHook.new(hook_uri)
    hook.call(payload(booking_location))
  end

  private

  def hook_uri
    ENV['BOOKING_REQUESTS_SLACK_PINGER_URI']
  end

  def payload(booking_location)
    {
      username: 'philbot',
      channel: '#centralised-bookings',
      text: "Alright guv' :rotating_light: #{booking_location.name} :rotating_light:",
      icon_emoji: ':phil:'
    }
  end
end
