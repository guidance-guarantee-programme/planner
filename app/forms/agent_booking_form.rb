class AgentBookingForm # rubocop:disable ClassLength
  include ActiveModel::Model

  ATTRIBUTES = %i(
    name
    email
    phone
    date_of_birth
    memorable_word
    accessibility_requirements
    defined_contribution_pot_confirmed
    terms_and_conditions
    address_line_one
    address_line_two
    address_line_three
    town
    county
    postcode
    where_you_heard
    first_choice_slot
    second_choice_slot
    third_choice_slot
    agent
    location_id
    booking_location_id
    additional_info
  ).freeze

  attr_accessor(*ATTRIBUTES)

  validates :name, presence: true
  validates :booking_location_id, presence: true
  validates :location_id, presence: true
  validates :date_of_birth, presence: true, format: %r{\d{1,2}\/\d{1,2}\/\d{2,4}}
  validates :email, presence: true, email: true, allow_blank: true
  validates :postcode, postcode: true, allow_blank: true
  validates :phone, presence: true, format: /\A([\d+\-\s\+()]+)\z/
  validates :memorable_word, presence: true
  validates :additional_info, length: { maximum: 320 }, allow_blank: true
  validates :where_you_heard, presence: true
  validates :defined_contribution_pot_confirmed, presence: true
  validates :terms_and_conditions, acceptance: { accept: '1' }
  validates :first_choice_slot, presence: true
  validate :validate_confirmation_details
  validate :validate_eligibility

  def address?
    [address_line_one, town, postcode].all?(&:present?)
  end

  def accessibility_requirements
    ActiveRecord::Type::Boolean.new.cast(@accessibility_requirements)
  end

  def marketing_opt_in
    ActiveRecord::Type::Boolean.new.cast(@marketing_opt_in)
  end

  def create_booking!
    BookingRequest.new(to_attributes).tap do |booking|
      build_slot(booking, priority: 1, slot: first_choice_slot)
      build_slot(booking, priority: 2, slot: second_choice_slot)
      build_slot(booking, priority: 3, slot: third_choice_slot)

      booking.save!
    end
  end

  private

  def validate_eligibility
    return if date_of_birth.blank?

    errors.add(:base, 'Must be aged 50 or over to be eligibile') if age < 50
  end

  def validate_confirmation_details
    unless address? || email_provided? # rubocop:disable GuardClause
      errors.add(:base, 'Please supply either an email or confirmation address')
    end
  end

  def email_provided?
    email.present? && email != 'tpbooking@pensionwise.gov.uk'
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
    date_of_birth = self.date_of_birth.in_time_zone

    age = Time.zone.today.year - date_of_birth.year
    age -= 1 if Time.zone.today.to_date < date_of_birth + age.years
    age
  end

  def to_attributes # rubocop:disable MethodLength, AbcSize
    {
      name: name,
      email: email,
      phone: phone,
      date_of_birth: date_of_birth,
      age_range: age_range,
      memorable_word: memorable_word,
      accessibility_requirements: accessibility_requirements,
      defined_contribution_pot_confirmed: defined_contribution_pot_confirmed,
      marketing_opt_in: terms_and_conditions,
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
      additional_info: additional_info
    }
  end

  def build_slot(booking, priority:, slot:)
    booking.slots << Slot.from(priority: priority, start_at: slot) if slot.present?
  end
end
