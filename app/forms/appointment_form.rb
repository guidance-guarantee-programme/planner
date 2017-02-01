class AppointmentForm
  include ActiveModel::Model

  BOOKING_REQUEST_ATTRIBUTES = %i(
    name
    email
    phone
    age_range
    date_of_birth
    reference
    location_name
    memorable_word
    accessibility_requirements
    primary_slot
    secondary_slot
    tertiary_slot
    booking_location
  ).freeze

  validates :location_id, presence: true
  validates :guider_id, presence: true
  validates :date, presence: true

  validate :validate_date
  validate :validate_not_with_an_existing_booking_request

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

  def appointment_params
    AppointmentMapper.map(self)
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

  def defined_contribution_pot_confirmed
    location_aware_booking_request.defined_contribution_pot_confirmed ? 'Yes' : 'Not sure'
  end

  private

  def validate_not_with_an_existing_booking_request
    errors.add(:base, 'has already been fulfilled') if location_aware_booking_request.appointment
  end

  def validate_date
    return unless date

    parsed_date = Date.parse(date.to_s)
    errors.add(:date, 'must be in the future') unless parsed_date > Date.current
  rescue ArgumentError
    errors.add(:date, 'must be formatted correctly')
  end

  def normalise_time(params)
    hour   = params.delete('time(4i)')
    minute = params.delete('time(5i)')

    @time = "#{hour}:#{minute}" if hour && minute
  end
end
