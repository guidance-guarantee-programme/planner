class BookableSlot < ActiveRecord::Base
  AM = Period.new('0900', '1300')
  PM = Period.new('1300', '1700')

  belongs_to :schedule

  audited associated_with: :schedule

  validate :validate_date_exclusions
  validate :validate_slot_allocation
  validate :validate_guider_overlapping

  scope :realtime, -> { where.not(guider_id: nil) }
  scope :non_realtime, -> { where(guider_id: nil) }

  def realtime?
    guider_id?
  end

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

  def start_at
    @start_at ||= Time.zone.parse("#{date} #{start.dup.insert(2, ':')}")
  end

  def end_at
    @end_at ||= Time.zone.parse("#{date} #{self.end.dup.insert(2, ':')}")
  end

  def overlaps?(bookable_slot)
    range.cover?(bookable_slot.start_at.advance(minutes: 1)) || range.cover?(bookable_slot.end_at.advance(minutes: -1))
  end

  def self.windowed(date_range)
    where(date: date_range)
  end

  def self.for_deletion(schedule_ids)
    where(schedule_id: schedule_ids)
      .where(arel_table[:date].gteq(Time.zone.now))
  end

  private

  def range
    start_at...end_at
  end

  def validate_guider_overlapping
    return unless guider_id?

    if self.class.where(date: date, guider_id: guider_id).any?(&method(:overlaps?)) # rubocop:disable GuardClause
      errors.add(:start, 'cannot overlap with another slot')
    end
  end

  def validate_slot_allocation # rubocop:disable AbcSize
    if guider_id?
      return unless slot = schedule.bookable_slots.non_realtime.last
      report_overlapping_slot_error if slot.date >= date
    else
      return unless slot = schedule.bookable_slots.realtime.first
      report_overlapping_slot_error if slot.date <= date
    end
  end

  def report_overlapping_slot_error
    errors.add(:date, 'cannot overlap realtime/non-realtime slots')
  end

  def validate_date_exclusions
    errors.add(:start, 'Cannot occur on this date') if EXCLUSIONS.include?(date)
  end
end
