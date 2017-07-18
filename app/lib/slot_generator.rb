module SlotGenerator
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
      *Schedule::SLOT_ATTRIBUTES.map(&:to_s)
    ).select { |_, v| v }
  end

  def slots_to_create
    return [] if scheduled_slots.empty?

    DefaultBookableSlots.new(**slot_window).call.select do |slot|
      scheduled_slots.key?(slot.label)
    end
  end

  attr_reader :schedule
end
