class BookableSlot < ActiveRecord::Base
  belongs_to :schedule

  def am?
    start == '0900'
  end

  def pm?
    !am?
  end

  def self.for_deletion(schedule_ids)
    where(schedule_id: schedule_ids)
      .where(arel_table[:date].gteq(Time.zone.now))
  end
end
