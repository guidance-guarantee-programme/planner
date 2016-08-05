if Rails.env.production? || Rails.env.staging?
  BookingLocations.cache = Rails.cache
else
  require 'booking_locations/stub_api'

  BookingLocations.api = BookingLocations::StubApi.new
end
