class BookableSlotGenerator
  def initialize(schedule)
    @schedule = schedule
  end

  def call
    Schedule.transaction do
      delete_existing_slots!
      create_scheduled_slots!
    end
  end

  private

  def create_scheduled_slots!
    slots_to_create.map do |slot|
      schedule.bookable_slots.create!(
        date: slot.date,
        start: slot.start,
        end: slot.end
      )
    end
  end

  def scheduled_slots
    @scheduled_slots ||= schedule.attributes.slice(
      *Schedule.slot_attributes.map(&:to_s)
    ).select { |_, v| v }
  end

  def slots_to_create
    return [] if scheduled_slots.empty?

    DefaultBookableSlots.new(to: 4.months.from_now).call.select do |slot|
      scheduled_slots.key?(slot.label)
    end
  end

  def delete_existing_slots!
    schedule_ids = Schedule.where(location_id: schedule.location_id).pluck(:id)

    BookableSlot.for_deletion(schedule_ids).delete_all
  end

  attr_reader :schedule
end
