class BookingRequest < ActiveRecord::Base
  PERMITTED_AGE_RANGES = %w(50-54 55-plus).freeze

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
  validate :validate_slots

  delegate :realtime?, to: :primary_slot, allow_nil: true

  alias reference to_param

  scope :placed_by_agents, lambda {
    includes(:slots, :agent)
      .where.not(agent_id: nil)
      .order(:created_at)
  }

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

  private

  def validate_slots
    errors.add(:slots, 'you must provide at least one slot') if slots.empty?

    return unless realtime?

    errors.add(:slots, 'could not be allocated') unless @allocated = Schedule.allocates?(self)
  end
end
