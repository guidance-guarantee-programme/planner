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
  ).freeze

  delegate(*BOOKING_REQUEST_ATTRIBUTES, to: :booking_request)

  def initialize(booking_request, params)
    @booking_request = booking_request
    super(params)
  end

  private

  attr_reader :booking_request
end
