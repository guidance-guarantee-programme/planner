class BookableSlot < ActiveRecord::Base
  AM = Period.new('0900', '1300')
  PM = Period.new('1300', '1700')

  belongs_to :schedule

  def am?
    AM.am?(start)
  end

  def pm?
    PM.pm?(start)
  end

  def self.for_deletion(schedule_ids)
    where(schedule_id: schedule_ids)
      .where(arel_table[:date].gteq(Time.zone.now))
  end
end
