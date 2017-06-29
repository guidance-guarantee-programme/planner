class SlackPingerJob < ActiveJob::Base
  include ActionView::Helpers::TextHelper

  queue_as :default

  def perform(booking_request)
    return unless hook_uri

    booking_location = BookingLocations.find(booking_request.location_id)
    actual_location  = booking_location.name_for(booking_request.location_id)

    hook = WebHook.new(hook_uri)
    hook.call(payload(actual_location, booking_request.slots.size))
  end

  private

  def hook_uri
    ENV['BOOKING_REQUESTS_SLACK_PINGER_URI']
  end

  def payload(actual_location, slot_count)
    slot_count = pluralize(slot_count, 'slot')

    {
      username: 'frank',
      channel: '#online-bookings',
      text: ":rotating_light: #{actual_location} (#{slot_count}) :rotating_light:",
      icon_emoji: ':frank:'
    }
  end
end
