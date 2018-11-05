class Schedule < ActiveRecord::Base
  SLOT_ATTRIBUTES = %i(
    monday_am
    monday_pm
    tuesday_am
    tuesday_pm
    wednesday_am
    wednesday_pm
    thursday_am
    thursday_pm
    friday_am
    friday_pm
  ).freeze

  has_many :bookable_slots, -> { order(:date, :start) }

  alias default? new_record?

  has_associated_audits
  audited on: :create

  def create_realtime_bookable_slot!(start_at:, guider_id:)
    bookable_slots.create!(
      guider_id: guider_id,
      date: start_at.to_date,
      start: start_at.strftime('%H%M'),
      end: start_at.advance(hours: 1).strftime('%H%M')
    )
  end

  def create_bookable_slot(date:, period:)
    bookable_slots.create!(
      date: date,
      start: period.start,
      end: period.end
    )
  end

  def generate_bookable_slots!
    BookableSlotGenerator.new(self).call
  end

  def create_bookable_slots(date:, am:, pm:)
    create_bookable_slot(date: date, period: BookableSlot::AM) if am
    create_bookable_slot(date: date, period: BookableSlot::PM) if pm
  end

  def bookable_slots_in_window(
    starting: GracePeriod.start,
    ending:   GracePeriod.end
  )
    return DefaultBookableSlots.new.call if default?

    bookable_slots.windowed(starting..ending)
  end

  def without_appointments(scoped = bookable_slots_in_window)
    scoped.joins(
      <<-SQL
        LEFT JOIN appointments ON
          appointments.guider_id = bookable_slots.guider_id
          AND appointments.proceeded_at = TO_TIMESTAMP(CONCAT(bookable_slots.date, ' ', bookable_slots.start), 'YYYY-MM-DD HH24MI')
          AND NOT appointments.status IN (5, 6, 7)
      SQL
    ).where('appointments.proceeded_at IS NULL')
  end

  def unavailable?
    return if default?

    without_appointments.size.zero?
  end

  def available?
    !unavailable?
  end

  def available_before?(from: 4.weeks.from_now)
    return false unless available?

    first_available_slot_on <= from
  end

  def first_available_slot_on
    return GracePeriod.new.call if default?

    without_appointments.first&.date
  end

  def self.allocates?(booking_request)
    schedule = current(booking_request.location_id)

    return true if schedule.default?

    schedule.without_appointments.find_by(
      date: booking_request.primary_slot.date,
      start: booking_request.primary_slot.from,
      end: booking_request.primary_slot.to
    )
  end

  def self.current(location_id)
    where(location_id: location_id)
      .order(created_at: :desc)
      .first_or_initialize(location_id: location_id)
  end
end
