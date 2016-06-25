class BookingRequest < ActiveRecord::Base
  PERMITTED_AGE_RANGES = %w(50-54 55-plus).freeze

  has_many :slots, -> { order(:priority) }

  accepts_nested_attributes_for :slots, limit: 3, allow_destroy: false

  validates :name, presence: true
  validates :location_id, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :memorable_word, presence: true
  validates :age_range, inclusion: { in: PERMITTED_AGE_RANGES }
  validates :accessibility_requirements, inclusion: { in: [true, false] }
  validates :marketing_opt_in, inclusion: { in: [true, false] }
  validates :defined_contribution_pot, inclusion: { in: [true, false] }
  validate :validate_slots

  alias reference to_param

  def primary_slot
    slots.first&.to_s
  end

  def secondary_slot
    slots.second&.to_s
  end

  def tertiary_slot
    slots.third&.to_s
  end

  private

  def validate_slots
    unless slots.map(&:priority).sort == [1, 2, 3]
      errors.add(:slots, 'you must provide a slot for each permitted priority (1, 2, 3)')
    end
  end
end
