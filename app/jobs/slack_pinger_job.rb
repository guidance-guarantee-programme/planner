class SlackPingerJob < ActiveJob::Base
  include ActionView::Helpers::TextHelper

  queue_as :default

  def perform(booking_request_or_appointment)
    return unless hook_uri

    booking_location = BookingLocations.find(booking_request_or_appointment.location_id)
    actual_location  = booking_location.name_for(booking_request_or_appointment.location_id)

    hook = WebHook.new(hook_uri)
    hook.call(payload(actual_location))
  end

  private

  def hook_uri
    ENV['BOOKING_REQUESTS_SLACK_PINGER_URI']
  end

  def payload(actual_location)
    {
      username: 'frank',
      channel: '#online-bookings',
      text: ":zap: #{actual_location} :zap:",
      icon_emoji: ':frank:'
    }
  end
end
