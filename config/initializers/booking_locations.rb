unless Rails.env.production?
  require 'booking_locations/stub_api'

  BookingLocations.api = BookingLocations::StubApi.new
end
