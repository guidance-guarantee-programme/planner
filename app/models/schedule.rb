class Schedule < ActiveRecord::Base
  SLOT_ATTRIBUTES = %i(
    monday_am
    monday_pm
    tuesday_am
    tuesday_pm
    wednesday_am
    wednesday_pm
    thursday_am
    thursday_pm
    friday_am
    friday_pm
  ).freeze

  has_many :bookable_slots, -> { order(:date) }

  alias default? new_record?

  def generate_bookable_slots!
    BookableSlotGenerator.new(self).call
  end

  def bookable_slots_in_window
    bookable_slots.windowed
  end

  def self.current(location_id)
    where(location_id: location_id)
      .order(created_at: :desc)
      .first_or_initialize(location_id: location_id)
  end
end
