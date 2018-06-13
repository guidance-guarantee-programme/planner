class AppointmentChangeNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment, log_activity = true)
    return unless appointment.email?

    booking_location = BookingLocations.find(appointment.location_id)

    Appointments.customer(appointment, booking_location).deliver

    AppointmentMailActivity.from(appointment) if log_activity
  end
end
