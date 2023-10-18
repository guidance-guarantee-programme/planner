class AppointmentForm # rubocop:disable Metrics/ClassLength
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
    recording_consent
    nudged
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
  validates :time, presence: true

  validate :validate_date
  validate :validate_time
  validate :validate_not_with_an_existing_booking_request
  validate :validate_guider_availability

  attr_reader :location_aware_booking_request, :time
  alias booking_request location_aware_booking_request

  attr_accessor :name, :email, :phone, :defined_contribution_pot_confirmed, :accessibility_requirements,
                :memorable_word, :date_of_birth, :guider_id, :location_id, :date, :additional_info

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

  def recording_consent
    @recording_consent ||= location_aware_booking_request.recording_consent
  end

  def nudged
    @nudged ||= location_aware_booking_request.nudged
  end

  def third_party
    @third_party ||= location_aware_booking_request.third_party
  end

  private

  def validate_guider_availability
    return unless [guider_id, date, time].all?(&:present?)

    proceeded_at = "#{date} #{time.to_s(:time)}"

    if Appointment.overlaps?(
      guider_id: guider_id, proceeded_at: proceeded_at, location_id: location_id
    )
      errors.add(:guider_id, 'is already booked with an overlapping appointment')
    end
  end

  def validate_not_with_an_existing_booking_request
    errors.add(:base, 'has already been fulfilled') if location_aware_booking_request.appointment
  end

  def validate_time
    return unless time

    errors.add(:time, 'must be during the permitted hours') unless (8..18).cover?(time.hour)
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

    @time = Time.zone.parse("#{hour}:#{minute}") if hour.present? && minute.present?
  end
end
