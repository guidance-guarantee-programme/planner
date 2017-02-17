class AppointmentReminderJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    booking_location = BookingLocations.find(appointment.location_id)

    ReminderActivity.from(appointment)

    Appointments.reminder(appointment, booking_location).deliver_later
  end
end
