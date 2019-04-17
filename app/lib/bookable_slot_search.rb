class BookableSlotSearch
  include ActiveModel::Model

  attr_accessor :date
  attr_accessor :location
  attr_accessor :guider
  attr_accessor :page
  attr_accessor :per_page

  def results # rubocop:disable AbcSize, MethodLength
    scope = Schedule.current(location.id).bookable_slots.realtime
    scope = scope.joins(
      <<-SQL
      LEFT JOIN appointments ON
        appointments.guider_id = bookable_slots.guider_id
        AND appointments.proceeded_at = TO_TIMESTAMP(CONCAT(bookable_slots.date, ' ', bookable_slots.start), 'YYYY-MM-DD HH24MI')
        AND NOT appointments.status IN (5, 6, 7)
      SQL
    )

    scope = scope.where(date: date_range)
    scope = scope.where(guider_id: guider) if guider.present?
    scope = scope.page(page).per(per_page)
    scope.select('bookable_slots.*, count(appointments.id) as appointment_count').group('bookable_slots.id')
  end

  private

  def date_range
    if date.blank?
      Date.current..2.years.from_now.to_date
    else
      Range.new(*date.split(' - ').map(&:to_date))
    end
  end
end
