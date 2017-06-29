class BookingRequest < ActiveRecord::Base
  PERMITTED_AGE_RANGES = %w(50-54 55-plus).freeze

  enum status: %i(
    active
    awaiting_customer_feedback
    hidden
  )

  has_one :appointment

  has_many :slots, -> { order(:priority) }, dependent: :destroy

  has_many :activities, -> { order('created_at DESC') }

  accepts_nested_attributes_for :slots, limit: 3, allow_destroy: false

  validates :name, presence: true
  validates :booking_location_id, presence: true
  validates :location_id, presence: true
  validates :email, presence: true, email: true
  validates :phone, presence: true
  validates :memorable_word, presence: true
  validates :age_range, inclusion: { in: PERMITTED_AGE_RANGES }
  validates :accessibility_requirements, inclusion: { in: [true, false] }
  validates :marketing_opt_in, inclusion: { in: [true, false] }
  validates :defined_contribution_pot_confirmed, inclusion: { in: [true, false] }
  validates :additional_info, length: { maximum: 160 }, allow_blank: true
  validate :validate_slots

  alias reference to_param

  def self.latest(email)
    where(email: email).order(:created_at).last
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

  private

  def validate_slots
    errors.add(:slots, 'you must provide at least one slot') if slots.empty?
  end
end
