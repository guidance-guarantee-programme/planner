class BookableSlotGenerator
  include SlotGenerator

  def initialize(schedule)
    @schedule = schedule
  end

  def call
    Schedule.transaction do
      delete_existing_slots!
      create_scheduled_slots!
    end
  end

  def slot_window
    Hash[to: 4.months.from_now]
  end

  private

  def delete_existing_slots!
    schedule_ids = Schedule.where(location_id: schedule.location_id).pluck(:id)

    BookableSlot.for_deletion(schedule_ids).delete_all
  end
end
