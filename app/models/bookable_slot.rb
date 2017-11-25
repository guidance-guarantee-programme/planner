class BookableSlot < ActiveRecord::Base
  AM = Period.new('0900', '1300')
  PM = Period.new('1300', '1700')

  belongs_to :schedule

  audited associated_with: :schedule

  def am?
    AM.am?(start)
  end

  def pm?
    PM.pm?(self.end)
  end

  def period
    am? ? 'am' : 'pm'
  end

  def appointments
    ending_at = am? ? end_at - 1.minute : end_at

    Appointment
      .where(location_id: schedule.location_id)
      .where(proceeded_at: start_at..ending_at)
  end

  def self.windowed(date_range)
    where(date: date_range)
  end

  def self.for_deletion(schedule_ids)
    where(schedule_id: schedule_ids)
      .where(arel_table[:date].gteq(Time.zone.now))
  end

  private

  def start_at
    Time.zone.parse("#{date} #{start.insert(2, ':')}")
  end

  def end_at
    Time.zone.parse("#{date} #{self.end.insert(2, ':')}")
  end
end
