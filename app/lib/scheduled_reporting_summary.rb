class ScheduledReportingSummary
  def call
    booking_enabled_locations.each do |location|
      schedule = Schedule.current(location.id)

      ReportingSummary.create!(
        location_id: location.id,
        name: location.title,
        four_week_availability: schedule.available_before?,
        first_available_slot_on: schedule.first_available_slot_on,
        last_slot_on: schedule.last_slot_on
      )
    end
  end

  private

  def booking_enabled_locations
    BookingLocations.all
  end
end
