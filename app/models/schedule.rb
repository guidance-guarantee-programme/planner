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

  has_many :bookable_slots, -> { order(:date, :start) }

  alias default? new_record?

  has_associated_audits
  audited on: :create

  def nicab?
    WindowEnd.new(location_id).nicab?
  end

  def generate_bookable_slots!
    BookableSlotGenerator.new(self).call
  end

  def create_bookable_slots(date:, am:, pm:)
    create_bookable_slot(date: date, period: BookableSlot::AM) if am
    create_bookable_slot(date: date, period: BookableSlot::PM) if pm
  end

  def bookable_slots_in_window(
    starting: GracePeriod.new.call,
    ending:   WindowEnd.new(location_id).call
  )
    return DefaultBookableSlots.new.call if default?

    bookable_slots.windowed(starting..ending)
  end

  def unavailable?
    return if default?

    bookable_slots_in_window.size.zero?
  end

  def available?
    !unavailable?
  end

  def available_before?(from: 4.weeks.from_now)
    return false unless available?

    first_available_slot_on <= from
  end

  def first_available_slot_on
    bookable_slots_in_window.first&.date
  end

  def self.current(location_id)
    where(location_id: location_id)
      .order(created_at: :desc)
      .first_or_initialize(location_id: location_id)
  end

  private

  def create_bookable_slot(date:, period:)
    bookable_slots.create!(
      date: date,
      start: period.start,
      end: period.end
    )
  end
end
