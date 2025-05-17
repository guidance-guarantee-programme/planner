class AgentBookingForm # rubocop:disable Metrics/ClassLength
  include ActiveModel::Model

  ATTRIBUTES = %i(
    name
    email
    phone
    date_of_birth
    memorable_word
    accessibility_requirements
    address_line_one
    address_line_two
    address_line_three
    town
    county
    postcode
    where_you_heard
    first_choice_slot
    agent
    location_id
    booking_location_id
    additional_info
    gdpr_consent
    nudged
    bsl
    third_party
    data_subject_name
    data_subject_date_of_birth
    adjustments
  ).freeze

  attr_accessor(*ATTRIBUTES)

  delegate :realtime?, to: :booking_request

  validates :name, presence: true
  validates :booking_location_id, presence: true
  validates :location_id, presence: true
  validates :email, presence: true, email: true, allow_blank: true
  validates :postcode, postcode: true, allow_blank: true
  validates :phone, presence: true, format: /\A([\d+\-\s+()]+)\z/
  validates :memorable_word, presence: true
  validates :additional_info, length: { maximum: 320 }, allow_blank: true
  validates :adjustments, presence: true, if: :require_adjustments?
  validates :where_you_heard, presence: true
  validates :gdpr_consent, inclusion: { in: %w(yes no) }
  validates :first_choice_slot, presence: true
  validates :data_subject_name, presence: true, if: :third_party?
  validates :data_subject_date_of_birth, presence: true, if: :third_party?

  validate :validate_confirmation_details
  validate :validate_eligibility
  validate :validate_bsl_slot_allocation

  def scheduled
    true
  end
  alias scheduled? scheduled

  BOOLEAN_ATTRS = %i(
    bsl
    nudged
    accessibility_requirements
    third_party
  ).freeze

  BOOLEAN_ATTRS.each do |boolean_attr|
    define_method boolean_attr do
      ActiveRecord::Type::Boolean.new.cast(instance_variable_get("@#{boolean_attr}"))
    end
    alias_method "#{boolean_attr}?", boolean_attr
  end

  def address?
    [address_line_one, town, postcode].all?(&:present?)
  end

  def create_booking!
    booking_request.tap(&:save!)
  end

  private

  def require_adjustments?
    accessibility_requirements?
  end

  def booking_request
    @booking_request ||= BookingRequest.new(to_attributes).tap do |booking|
      build_slot(booking, priority: 1, slot: first_choice_slot.delete(BookableSlot::BSL_SLOT_DESIGNATOR))
    end
  end

  def parsed_date_of_birth
    date_of_birth.to_date
  rescue ArgumentError
    nil
  end

  def bsl_slot?
    first_choice_slot.starts_with?(BookableSlot::BSL_SLOT_DESIGNATOR)
  end

  def validate_bsl_slot_allocation
    return unless bsl_slot?
    return if bsl? || accessibility_requirements?

    errors.add(:base, 'BSL or adjustments must be specified when choosing a BSL/double slot')
  end

  def validate_eligibility
    errors.add(:date_of_birth, 'must be formatted eg 01/01/1950') if parsed_date_of_birth.blank?
  end

  def validate_confirmation_details
    unless address? || email_provided? # rubocop:disable Style/GuardClause
      errors.add(:base, 'Please supply either an email or confirmation address')
    end
  end

  def email_provided?
    email.present? && /tpbookings?@pensionwise.gov.uk/ !~ email
  end

  def age_range
    if age < 50
      'under-50'
    elsif (50..54).cover?(age)
      '50-54'
    else
      '55-plus'
    end
  end

  def age
    return 0 unless at = earliest_slot_time
    return 0 unless date_of_birth = parsed_date_of_birth

    age = at.year - date_of_birth.year
    age -= 1 if at.to_date < date_of_birth + age.years
    age
  end

  def earliest_slot_time
    first_choice_slot.delete(BookableSlot::BSL_SLOT_DESIGNATOR).in_time_zone
  end

  def to_attributes # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    {
      name: name,
      email: email,
      phone: phone,
      date_of_birth: date_of_birth,
      age_range: age_range,
      memorable_word: memorable_word,
      accessibility_requirements: accessibility_requirements,
      defined_contribution_pot_confirmed: true,
      address_line_one: address_line_one,
      address_line_two: address_line_two,
      address_line_three: address_line_three,
      town: town,
      county: county,
      postcode: postcode,
      where_you_heard: where_you_heard,
      agent: agent,
      location_id: location_id,
      booking_location_id: booking_location_id,
      additional_info: additional_info,
      gdpr_consent: gdpr_consent,
      nudged: nudged,
      bsl: bsl,
      third_party: third_party,
      data_subject_name: data_subject_name,
      data_subject_date_of_birth: data_subject_date_of_birth,
      adjustments: adjustments
    }
  end

  def build_slot(booking, priority:, slot:)
    booking.slots << Slot.from(priority: priority, slot: slot) if slot.present?
  end
end
