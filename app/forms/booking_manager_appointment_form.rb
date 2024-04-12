class BookingManagerAppointmentForm # rubocop:disable Metrics/ClassLength
  include ActiveModel::Model

  ATTRIBUTES = %i(
    name
    email
    phone
    date_of_birth
    memorable_word
    accessibility_requirements
    defined_contribution_pot_confirmed
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
    guider_id
    ad_hoc_start_at
    scheduled
    recording_consent
    bsl
    third_party
    welsh
    data_subject_name
    data_subject_date_of_birth
    data_subject_consent_obtained
    power_of_attorney
    email_consent_form_required
    email_consent
    printed_consent_form_required
    consent_address_line_one
    consent_address_line_two
    consent_address_line_three
    consent_town
    consent_county
    consent_postcode
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
  validates :additional_info, presence: true, if: :accessibility_requirements
  validates :where_you_heard, presence: true
  validates :defined_contribution_pot_confirmed, presence: true
  validates :gdpr_consent, inclusion: { in: ['yes', 'no', ''] }
  validates :first_choice_slot, presence: true, if: :scheduled?
  validates :ad_hoc_start_at, presence: true, unless: :scheduled?
  validates :guider_id, presence: true, unless: :scheduled?
  validates :email_consent, presence: true, email: true, if: :email_consent_form_required?
  validates :data_subject_name, presence: true, if: :third_party?
  validates :data_subject_date_of_birth, presence: true, if: :third_party?

  validate :validate_printed_consent_form_address
  validate :validate_consent_type
  validate :validate_power_of_attorney_or_consent
  validate :validate_confirmation_details
  validate :validate_eligibility
  validate :validate_guider_availability, unless: :scheduled?

  BOOLEAN_ATTRS = %i(
    scheduled
    accessibility_requirements
    recording_consent
    third_party
    email_consent_form_required
    printed_consent_form_required
    power_of_attorney
    data_subject_consent_obtained
    bsl
    welsh
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

  def create_appointment!
    booking_request.tap(&:save!)
  end

  private

  def validate_printed_consent_form_address
    return unless third_party? && printed_consent_form_required?

    errors.add(:printed_consent_form_required, 'must supply a valid address') unless printed_consent_address?
  end

  def validate_power_of_attorney_or_consent
    return unless third_party?

    if printed_consent_form_required? && power_of_attorney?
      errors.add(:printed_consent_form_required, 'cannot be checked when power of attorney is specified')
    end

    if email_consent_form_required? && power_of_attorney? # rubocop:disable Style/GuardClause
      errors.add(:email_consent_form_required, 'cannot be checked when power of attorney is specified')
    end
  end

  def validate_consent_type
    return unless third_party?

    if power_of_attorney? && data_subject_consent_obtained? # rubocop:disable Style/GuardClause
      errors.add(
        :third_party,
        "you may only specify 'data subject consent obtained', 'power of attorney' or neither"
      )
    end
  end

  def email_consent_valid
    unless /.+@.+\..+/.match?(email_consent.to_s) # rubocop:disable Style/GuardClause
      errors.add(:email_consent, 'must be valid')
    end
  end

  def printed_consent_address?
    [consent_address_line_one, consent_town, consent_postcode].all?(&:present?)
  end

  def booking_request
    @booking_request ||= BookingRequest.new(to_attributes).tap do |booking|
      slot = scheduled ? first_choice_slot : ad_hoc_start_at

      build_slot(booking, priority: 1, slot: slot)
    end
  end

  def parsed_date_of_birth
    date_of_birth.to_date
  rescue ArgumentError
    nil
  end

  def validate_eligibility
    unless %r{\d{1,2}/\d{1,2}/\d{4}}.match?(date_of_birth) || parsed_date_of_birth.blank?
      errors.add(:date_of_birth, 'must be formatted eg 01/01/1950')
      return
    end

    errors.add(:base, 'Must be aged 50 or over to be eligible') if age < 50
  end

  def validate_confirmation_details
    unless address? || email_provided? # rubocop:disable Style/GuardClause
      errors.add(:base, 'Please supply either an email or confirmation address')
    end
  end

  def validate_guider_availability
    return unless guider_id.present? && ad_hoc_start_at.present?

    if Appointment.overlaps?(
      guider_id: guider_id, proceeded_at: ad_hoc_start_at, location_id: location_id
    )
      errors.add(:guider_id, 'is already booked with an overlapping appointment')
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
    scheduled ? first_choice_slot.in_time_zone : ad_hoc_start_at&.in_time_zone
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
      defined_contribution_pot_confirmed: defined_contribution_pot_confirmed,
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
      guider_id: scheduled ? '' : guider_id,
      recording_consent: recording_consent,
      bsl: bsl,
      third_party: third_party,
      welsh: welsh,
      data_subject_name: data_subject_name,
      data_subject_date_of_birth: data_subject_date_of_birth,
      data_subject_consent_obtained: data_subject_consent_obtained,
      power_of_attorney: power_of_attorney,
      email_consent_form_required: email_consent_form_required,
      email_consent: email_consent,
      printed_consent_form_required: printed_consent_form_required,
      consent_address_line_one: consent_address_line_one,
      consent_address_line_two: consent_address_line_two,
      consent_address_line_three: consent_address_line_three,
      consent_town: consent_town,
      consent_county: consent_county,
      consent_postcode: consent_postcode
    }
  end

  def build_slot(booking, priority:, slot:)
    booking.slots << Slot.from(priority: priority, slot: slot) if slot.present?
  end
end
