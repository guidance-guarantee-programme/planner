class AvailabilityForm
  include ActiveModel::Model

  attr_accessor :date
  attr_accessor :schedule_id
  attr_accessor :am
  attr_accessor :pm

  def am?
    slots.any?(&:am?)
  end

  def pm?
    slots.any?(&:pm?)
  end

  def date
    @date.to_date
  end

  def schedule
    @schedule ||= Schedule.find(schedule_id)
  end

  def upsert!
    ActiveRecord::Base.transaction do
      slots.delete_all

      schedule.create_bookable_slots(date: date, am: am, pm: pm)
    end
  end

  private

  def slots
    schedule.bookable_slots_in_window(
      starting: date,
      ending: date
    ).non_realtime
  end
end
