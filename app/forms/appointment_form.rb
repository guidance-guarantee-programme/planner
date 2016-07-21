class AppointmentForm
  include ActiveModel::Model

  BOOKING_REQUEST_ATTRIBUTES = %i(
    name
    email
    phone
    age_range
    reference
    location_id
    location_name
    memorable_word
    accessibility_requirements
    primary_slot
    secondary_slot
    tertiary_slot
    booking_location
  ).freeze

  attr_reader :location_aware_booking_request
  attr_reader :guider_id
  attr_reader :location_id

  delegate(*BOOKING_REQUEST_ATTRIBUTES, to: :location_aware_booking_request)

  delegate :guiders, to: :booking_location

  def initialize(location_aware_booking_request, params)
    @location_aware_booking_request = location_aware_booking_request
    super(params)
  end

  def flattened_locations
    FlattenedLocationMapper.map(booking_location)
  end
end
