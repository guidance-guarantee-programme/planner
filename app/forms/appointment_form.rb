class AppointmentForm
  include ActiveModel::Model

  BOOKING_REQUEST_ATTRIBUTES = %i(
    name
    email
    phone
    age_range
    reference
    location_name
    memorable_word
    accessibility_requirements
    primary_slot
    secondary_slot
    tertiary_slot
    booking_location
  ).freeze

  attr_reader :location_aware_booking_request

  attr_accessor :guider_id
  attr_accessor :location_id
  attr_accessor :date

  delegate(*BOOKING_REQUEST_ATTRIBUTES, to: :location_aware_booking_request)

  delegate :guiders, to: :booking_location

  def initialize(location_aware_booking_request, params)
    @location_aware_booking_request = location_aware_booking_request
    normalise_time(params)
    super(params)
  end

  def flattened_locations
    FlattenedLocationMapper.map(booking_location)
  end

  def location_id
    @location_id ||= location_aware_booking_request.location_id
  end

  def date
    @date ||= location_aware_booking_request.primary_slot.date
  end

  def time
    @time ||= location_aware_booking_request.primary_slot.delimited_from

    Time.zone.parse(@time)
  end

  private

  def normalise_time(params)
    hour   = params.delete('time(4i)')
    minute = params.delete('time(5i)')

    @time = "#{hour}:#{minute}" if hour && minute
  end
end
