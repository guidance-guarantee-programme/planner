class CachedBookingLocationsApi
  def initialize(cache: Rails.cache, booking_locations_api: BookingLocations::Api.new)
    @cache = cache
    @booking_locations_api = booking_locations_api
  end

  def get(location_id)
    cache.fetch(location_id, expires_in: 2.hours) do
      booking_locations_api.get(location_id) do |response_hash|
        BookingLocations::Location.new(response_hash)
      end
    end
  end

  private

  attr_reader :cache
  attr_reader :booking_locations_api
end
