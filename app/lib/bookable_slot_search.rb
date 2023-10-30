class BookableSlotSearch
  include ActiveModel::Model

  attr_accessor :date, :location, :guider, :page, :per_page

  def results # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    scope = Schedule.current(location.id).bookable_slots.realtime
    scope = scope.joins(
      <<-SQL
      LEFT JOIN appointments ON
        appointments.guider_id = bookable_slots.guider_id
        AND appointments.proceeded_at = bookable_slots.start_at
        AND NOT appointments.status IN (5, 6, 7)
      SQL
    )

    scope = scope.where(start_at: date_range)
    scope = scope.where(guider_id: guider) if guider.present?
    scope = scope.page(page).per(per_page)
    scope.select('bookable_slots.*, count(appointments.id) as appointment_count').group('bookable_slots.id')
  end

  private

  def date_range
    if date.blank?
      Date.current.beginning_of_day..2.years.from_now
    else
      starts, ends = date.split(' - ').map(&:to_date)
      starts.beginning_of_day..ends.end_of_day
    end
  end
end
