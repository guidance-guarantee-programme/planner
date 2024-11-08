class LocationAwareEntity < SimpleDelegator
  attr_reader :booking_location

  def initialize(booking_location:, entity:)
    @booking_location = booking_location
    super(entity)
  end

  delegate :accessibility_information, to: :actual_location

  def online_booking_reply_to
    actual_location.online_booking_reply_to.presence || booking_location.online_booking_reply_to
  end

  def online_booking_twilio_number
    actual_location&.online_booking_twilio_number.to_s.sub(/^\+44/, '0')
  end

  def booking_location_name # rubocop:disable Rails/Delegate
    booking_location.name
  end

  def location_name
    actual_location.name
  end

  def guider_name
    return '' unless respond_to?(:guider_id) && guider_id

    booking_location.guider_name_for(guider_id)
  end

  def address_lines
    actual_location.address.split(', ')
  end

  def self.model_name
    OpenStruct.new(name: 'LocationAwareEntity')
  end

  alias entity __getobj__

  private

  def actual_location
    @actual_location ||= BookingLocationDecorator.new(
      booking_location.location_for(location_id)
    )
  end
end
