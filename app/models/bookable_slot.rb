class BookableSlot < ActiveRecord::Base
  BSL_SLOT_DESIGNATOR = '*'.freeze

  belongs_to :schedule

  audited associated_with: :schedule

  validate :validate_date_exclusions
  validate :validate_guider_overlapping
  validate :validate_appointment_overlapping
  validate :validate_permitted_date

  scope :realtime, -> { where.not(guider_id: nil) }
  scope :non_realtime, -> { where(guider_id: nil) }

  def realtime?
    guider_id?
  end

  def permitted_date?
    start_at < Time.zone.parse('2026-02-28 23:59')
  end

  def self.windowed(date_range)
    where(start_at: date_range)
  end

  def self.bsl_slots_to_revert # rubocop:disable Metrics/MethodLength
    slot_date = 7.working.days.from_now

    joins(
      <<-SQL
        LEFT JOIN appointments ON
          appointments.guider_id = bookable_slots.guider_id
          AND (appointments.proceeded_at, interval '1 hour')
          OVERLAPS (bookable_slots.start_at, interval '1 hour')
          AND NOT appointments.status IN (5, 6, 7)
      SQL
    ).where('appointments.proceeded_at IS NULL')
      .where(start_at: slot_date.beginning_of_day..slot_date.end_of_day)
      .where(bsl: true)
  end

  private

  def validate_appointment_overlapping # rubocop:disable Metrics/AbcSize
    return unless guider_id? && start_at?
    return unless overlapping = Appointment.overlapping(guider_id: guider_id, proceeded_at: start_at).first

    if overlapping.location_id == schedule.location_id
      errors.add(:base, 'overlaps an existing appointment in the same schedule')
    else
      errors.add(:base, 'overlaps an existing appointment in a different schedule')
    end

    logger.info("Appointment overlaps: #{overlapping.location_id}, #{schedule.location_id}, #{start_at}")
  end

  def validate_guider_overlapping # rubocop:disable Metrics/AbcSize
    return unless guider_id?
    return unless overlapping = self.class.where(
      "(start_at, interval '1 hour') overlaps (?, interval '1 hour')", start_at
    ).find_by(guider_id: guider_id)

    if overlapping.schedule_id == schedule_id
      errors.add(:base, 'overlaps with a slot in the same schedule')
    else
      errors.add(:base, 'overlaps with a slot in a different schedule')
    end

    logger.info("Guider overlaps: #{overlapping.schedule_id}, #{schedule_id}, #{start_at}")
  end

  def report_overlapping_slot_error
    errors.add(:base, 'cannot overlap realtime/non-realtime slots')
  end

  def validate_date_exclusions
    return unless schedule

    errors.add(:base, 'cannot occur on this date as it is a listed exclusion') if Exclusions
                                                                                  .new
                                                                                  .include?(start_at.to_date)
  end

  def validate_permitted_date
    errors.add(:base, 'cannot occur on this date as a block is in place') unless permitted_date?
  end
end
