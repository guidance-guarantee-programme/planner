class BookableSlotRegenerator
  include SlotGenerator

  def initialize(schedule)
    @schedule = schedule
  end

  def call
    Schedule.transaction { create_scheduled_slots! }
  end

  def slot_window
    {
      from: schedule.bookable_slots.last.date,
      to:   schedule.bookable_slots.last.date.advance(months: 4)
    }
  end
end
