class AppointmentChangeNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    booking_location = BookingLocations.find(appointment.location_id)

    Appointments.customer(appointment, booking_location).deliver

    AppointmentMailActivity.from(appointment)
  end
end
