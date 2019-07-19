class LocationAwareEntity < SimpleDelegator
  attr_reader :booking_location

  def initialize(booking_location:, entity:)
    @booking_location = booking_location
    super(entity)
  end

  delegate :online_booking_reply_to, to: :booking_location

  def online_booking_twilio_number
    actual_location&.online_booking_twilio_number.to_s.sub(/^\+44/, '0')
  end

  def location_name
    actual_location.name
  end

  def guider_name
    return '' unless respond_to?(:guider_id)

    booking_location.guider_name_for(guider_id)
  end

  def address_lines
    actual_location.address.split(', ')
  end

  alias entity __getobj__

  private

  def actual_location
    @actual_location ||= BookingLocationDecorator.new(
      booking_location.location_for(location_id)
    )
  end
end
