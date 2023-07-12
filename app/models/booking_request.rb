class BookingRequest < ActiveRecord::Base # rubocop:disable ClassLength
  PERMITTED_AGE_RANGES = %w(under-50 50-54 55-plus).freeze

  include PostalAddressable

  attr_accessor :guider_id
  attr_reader :allocated

  enum status: %i(
    active
    awaiting_customer_feedback
    hidden
  )

  belongs_to :agent, class_name: 'User', optional: true

  has_one :appointment, dependent: :destroy

  has_many :slots, -> { order(:priority) }, dependent: :destroy

  has_many :activities, -> { order('created_at DESC') }, dependent: :destroy

  accepts_nested_attributes_for :slots, limit: 3, allow_destroy: false

  validates :name, presence: true
  validates :booking_location_id, presence: true
  validates :location_id, presence: true
  validates :email, presence: true, email: true, unless: :agent_id?
  validates :phone, presence: true
  validates :memorable_word, presence: true
  validates :age_range, inclusion: { in: PERMITTED_AGE_RANGES }
  validates :accessibility_requirements, inclusion: { in: [true, false] }
  validates :defined_contribution_pot_confirmed, inclusion: { in: [true, false] }
  validates :placed_by_agent, inclusion: { in: [true, false] }
  validates :additional_info, length: { maximum: 320 }, allow_blank: true
  validates :where_you_heard, presence: true
  validates :gdpr_consent, inclusion: { in: ['yes', 'no', ''] }

  validates :email_consent, presence: true, email: true, if: :email_consent_form_required?
  validates :data_subject_name, presence: true, if: :third_party?
  validates :data_subject_date_of_birth, presence: true, if: :third_party?

  validate :validate_printed_consent_form_address
  validate :validate_consent_type
  validate :validate_power_of_attorney_or_consent

  validate :validate_slots, on: :create

  delegate :realtime?, to: :primary_slot, allow_nil: true

  has_one_attached :data_subject_consent_evidence
  has_one_attached :power_of_attorney_evidence

  alias reference to_param

  def self.for_redaction
    where
      .not(name: 'redacted')
      .where('created_at < ?', 2.years.ago.beginning_of_day)
  end

  def self.latest(email)
    where(email: email).order(:created_at).last
  end

  def consent
    gdpr_consent.present? ? gdpr_consent.titleize : 'No response'
  end

  def memorable_word(obscure: false)
    return super() unless obscure

    super().to_s.gsub(/(?!\A).(?!\Z)/, '*')
  end

  def primary_slot
    slots.first
  end

  def secondary_slot
    slots.second
  end

  def tertiary_slot
    slots.third
  end

  def name
    super.to_s.titleize
  end

  def address?
    [address_line_one, town, postcode].all?(&:present?)
  end

  def data_subject_date_of_birth
    super&.strftime('%d/%m/%Y')
  end

  private

  def validate_slots
    errors.add(:slots, 'you must provide at least one slot') if slots.empty?

    return unless realtime?

    errors.add(:slots, 'could not be allocated') unless @allocated = Schedule.allocates?(self)
  end

  def validate_printed_consent_form_address
    return unless third_party? && printed_consent_form_required?

    errors.add(:printed_consent_form_required, 'must supply a valid address') unless printed_consent_address?
  end

  def validate_power_of_attorney_or_consent
    return unless third_party?

    if printed_consent_form_required? && power_of_attorney?
      errors.add(:printed_consent_form_required, 'cannot be checked when power of attorney is specified')
    end

    if email_consent_form_required? && power_of_attorney? # rubocop:disable GuardClause
      errors.add(:email_consent_form_required, 'cannot be checked when power of attorney is specified')
    end
  end

  def validate_consent_type
    return unless third_party?

    if power_of_attorney? && data_subject_consent_obtained? # rubocop:disable GuardClause
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
end
