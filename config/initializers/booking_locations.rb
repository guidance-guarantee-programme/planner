unless Rails.env.production? || Rails.env.staging?
  require 'booking_locations/stub_api'

  BookingLocations.api = BookingLocations::StubApi.new
end
