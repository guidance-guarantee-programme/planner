if Rails.env.production? || Rails.env.staging?
  require 'cached_booking_locations_api'

  BookingLocations.api = CachedBookingLocationsApi.new
else
  require 'booking_locations/stub_api'

  BookingLocations.api = BookingLocations::StubApi.new
end
