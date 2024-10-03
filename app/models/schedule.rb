class Schedule < ActiveRecord::Base # rubocop:disable Metrics/ClassLength
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

  has_many :bookable_slots, -> { order(:start_at) }, dependent: :destroy

  has_associated_audits
  audited on: :create

  def realtime?
    without_appointments.realtime.size.positive?
  end

  def build_realtime_bookable_slot(start_at:, guider_id:)
    bookable_slots.build(
      guider_id: guider_id,
      start_at: start_at,
      end_at: start_at.advance(hours: 1)
    )
  end

  def create_realtime_bookable_slot(start_at:, guider_id:)
    bookable_slots.create(
      guider_id: guider_id,
      start_at: start_at,
      end_at: start_at.advance(hours: 1)
    )
  end

  def bookable_slots_in_window(starting: grace_period.start, ending: grace_period.end)
    bookable_slots.windowed(starting.beginning_of_day..ending.end_of_day)
  end

  def without_appointments(scoped = bookable_slots_in_window)
    scoped.joins(
      <<-SQL
        LEFT JOIN appointments ON
          appointments.guider_id = bookable_slots.guider_id
          AND (appointments.proceeded_at, interval '1 hour')
          OVERLAPS (bookable_slots.start_at, interval '1 hour')
          AND NOT appointments.status IN (5, 6, 7)
      SQL
    ).where('appointments.proceeded_at IS NULL')
  end

  def total_slots_created
    bookable_slots_in_window.size
  end

  def total_slots_available
    without_appointments.size
  end

  def grouped_slots
    without_appointments
      .realtime
      .select('start_at::date as date, start_at')
      .reorder(Arel.sql('start_at::date'), :start_at)
      .group_by(&:date)
      .transform_values { |value| value.map(&:start_at).uniq }
  end

  def unavailable?
    without_appointments.empty?
  end

  def available?
    !unavailable?
  end

  def available_before?(from: 4.weeks.from_now)
    return false unless available?

    first_available_slot_on <= from
  end

  def first_available_slot_on
    without_appointments.first&.start_at
  end

  def last_slot_on
    bookable_slots_in_window.last&.start_at
  end

  def self.allocates?(booking_request)
    schedule = current(booking_request.location_id)

    if booking_request.guider_id.present?
      schedule.without_appointments.find_or_create_by(
        start_at: booking_request.primary_slot.start_at,
        end_at: booking_request.primary_slot.end_at,
        guider_id: booking_request.guider_id
      )
    else
      schedule.without_appointments.find_by(start_at: booking_request.primary_slot.start_at)
    end
  end

  def self.allocate_slot(appointment, slot_date_time)
    schedule = current(appointment.location_id)

    schedule.without_appointments.find_by(start_at: slot_date_time)
  end

  def self.current(location_id)
    where(location_id: location_id)
      .order(created_at: :desc)
      .find_or_create_by!(location_id: location_id)
  end

  private

  def grace_period
    @grace_period ||= GracePeriod.new(location_id)
  end
end
