class CachedBookingLocationsApi < BookingLocations::Api
  def initialize(cache: Rails.cache)
    @cache = cache
  end

  def find(location_id)
    cache.fetch(location_id, expires_in: 2.hours) do
      super
    end
  end

  private

  attr_reader :cache
end
