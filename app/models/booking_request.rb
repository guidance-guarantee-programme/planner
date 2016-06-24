class BookingRequest < ActiveRecord::Base
  has_many :slots, -> { order(:priority) }

  accepts_nested_attributes_for :slots, limit: 3, allow_destroy: false

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
end
