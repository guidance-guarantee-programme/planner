class ScheduleRegeneration
  attr_reader :window

  def initialize(window: 6.weeks.from_now)
    @window = window
  end

  def call
    schedules_for_regeneration.find_each(&:regenerate_bookable_slots!)
  end

  def schedules_for_regeneration
    Schedule
      .joins(:bookable_slots)
      .group(:id)
      .having('max(bookable_slots.date) = ?', window)
  end
end
