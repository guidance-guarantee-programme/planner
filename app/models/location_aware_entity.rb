class LocationAwareEntity < SimpleDelegator
  attr_reader :booking_location

  def initialize(booking_location:, entity:)
    @booking_location = booking_location
    super(entity)
  end

  def location_name
    booking_location.name_for(location_id)
  end

  def guider_name
    return '' unless respond_to?(:guider_id)

    booking_location.guider_name_for(guider_id)
  end

  def address_lines
    actual_location.address.split(', ')
  end

  private

  def actual_location
    booking_location.location_for(location_id)
  end
end
