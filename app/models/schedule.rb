class Schedule < ActiveRecord::Base
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

  def self.slot_attributes
    columns_hash
      .keys
      .select { |k| /_[a|p]m\z/ === k } # rubocop:disable Style/CaseEquality
      .map(&:to_sym)
  end
end
