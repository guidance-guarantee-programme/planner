class AppointmentReminderJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless appointment.email?

    booking_location = BookingLocations.find(appointment.location_id)

    ReminderActivity.from(appointment)

    Appointments.reminder(appointment, booking_location).deliver_later
  end
end
