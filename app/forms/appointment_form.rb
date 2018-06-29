class AppointmentForm
  include ActiveModel::Model
  include PostalAddressable

  BOOKING_REQUEST_ATTRIBUTES = %i(
    reference
    location_name
    primary_slot
    secondary_slot
    tertiary_slot
    booking_location
    additional_info
    agent
    address?
    consent
    email?
  ).freeze

  validates :name, presence: true
  validates :email, presence: true, email: true, unless: :address?
  validates :phone, presence: true
  validates :memorable_word, presence: true
  validates :accessibility_requirements, inclusion: { in: [true, false, '1', '0'] }
  validates :defined_contribution_pot_confirmed, inclusion: { in: %w(true false) }

  validates :guider_id, presence: true
  validates :location_id, presence: true
  validates :date, presence: true

  validate :validate_date
  validate :validate_not_with_an_existing_booking_request

  attr_reader :location_aware_booking_request
  attr_reader :time
  alias booking_request location_aware_booking_request

  attr_accessor :name
  attr_accessor :email
  attr_accessor :phone
  attr_accessor :defined_contribution_pot_confirmed
  attr_accessor :accessibility_requirements
  attr_accessor :memorable_word
  attr_accessor :date_of_birth
  attr_accessor :guider_id
  attr_accessor :location_id
  attr_accessor :date
  attr_accessor :additional_info

  delegate(*BOOKING_REQUEST_ATTRIBUTES, to: :location_aware_booking_request)

  def initialize(location_aware_booking_request, params)
    @location_aware_booking_request = location_aware_booking_request
    normalise_time(params)
    normalise_date_of_birth(params)
    super(params)
  end

  def appointment_params
    AppointmentMapper.map(self)
  end

  def name
    @name ||= location_aware_booking_request.name
  end

  def email
    @email ||= location_aware_booking_request.email
  end

  def phone
    @phone ||= location_aware_booking_request.phone
  end

  def memorable_word
    @memorable_word ||= location_aware_booking_request.memorable_word
  end

  def location_id
    @location_id ||= location_aware_booking_request.location_id
  end

  def additional_info
    @additional_info ||= location_aware_booking_request.additional_info
  end

  def defined_contribution_pot_confirmed
    @defined_contribution_pot_confirmed ||= location_aware_booking_request.defined_contribution_pot_confirmed
  end

  def accessibility_requirements
    @accessibility_requirements ||= location_aware_booking_request.accessibility_requirements
  end

  private

  def validate_not_with_an_existing_booking_request
    errors.add(:base, 'has already been fulfilled') if location_aware_booking_request.appointment
  end

  def validate_date
    return unless date

    parsed_date = Date.parse(date.to_s)
    errors.add(:date, 'must be in the future') unless parsed_date >= Date.current
  rescue ArgumentError
    errors.add(:date, 'must be formatted correctly')
  end

  def normalise_date_of_birth(params)
    day   = params.delete('date_of_birth(3i)') || location_aware_booking_request.date_of_birth.day
    month = params.delete('date_of_birth(2i)') || location_aware_booking_request.date_of_birth.month
    year  = params.delete('date_of_birth(1i)') || location_aware_booking_request.date_of_birth.year

    @date_of_birth = Date.parse("#{year}-#{month}-#{day}")
  end

  def normalise_time(params)
    hour   = params.delete('time(4i)')
    minute = params.delete('time(5i)')

    @time = Time.zone.parse("#{hour}:#{minute}") if hour && minute
  end
end
