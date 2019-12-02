class LocationSearch
  include ActiveModel::Model

  METRES_PER_MILE = 1609.344

  attr_accessor :postcode
  attr_accessor :booking_location

  validates :postcode, postcode: true, if: -> { postcode.present? }

  def results # rubocop:disable AbcSize
    return [] unless postcode.present? && valid?

    start_point = point(geocoded_postcode)

    flattened_locations.each_with_object([]) do |location, memo|
      end_point = point(location.coordinates.reverse)
      distance  = start_point.distance(end_point) / METRES_PER_MILE

      memo << LocationSearchResult.new(location, distance)
    end.sort_by(&:numerical_distance)
  end

  private

  def point(lat_lng)
    RGeo::Geographic.spherical_factory.point(lat_lng[1], lat_lng[0])
  end

  def flattened_locations
    [
      booking_location,
      booking_location.locations.reject(&:hidden?)
    ].flatten
  end

  def geocoded_postcode
    Geocoder.lookup(postcode)
  end
end
