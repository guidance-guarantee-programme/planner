class FlattenedLocationMapper
  def self.map(booking_location)
    [].tap do |locations|
      locations << [booking_location.name, booking_location.id]

      booking_location.locations.each do |location|
        locations << [location.name, location.id]
      end
    end
  end
end
