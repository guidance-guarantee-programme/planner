class GuiderLookup < ActiveRecord::Base
  def self.populate # rubocop:disable MethodLength
    BookingRequest.distinct.pluck(:booking_location_id).each do |booking_location_id|
      if location = BookingLocations.find(booking_location_id)
        location.guiders.each do |guider|
          find_or_create_by(
            guider_id: guider.id,
            name: guider.name,
            booking_location_id: booking_location_id
          )
        end
      else
        logger.warn("Booking location could not be found for: #{booking_location_id}")
      end
    end
  end
end
