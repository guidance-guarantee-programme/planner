class AppointmentChangeNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless appointment.email?

    booking_location = BookingLocations.find(appointment.location_id)

    Appointments.customer(appointment, booking_location).deliver

    AppointmentMailActivity.from(appointment)
  end
end
