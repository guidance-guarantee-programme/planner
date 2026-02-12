class AppointmentVideoUrlNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless appointment.email?

    booking_location = BookingLocations.find(appointment.location_id)

    Appointments.customer_video_appointment(appointment, booking_location).deliver_now

    VideoAppointmentUrlActivity.from(appointment)
  end
end
