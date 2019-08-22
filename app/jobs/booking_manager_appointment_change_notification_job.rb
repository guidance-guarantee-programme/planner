class BookingManagerAppointmentChangeNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    booking_managers = User.booking_managers(appointment.booking_location_id)

    raise BookingManagersNotFoundError if booking_managers.blank?

    booking_managers.each do |booking_manager|
      Appointments.booking_manager_appointment_changed(
        appointment,
        booking_manager
      ).deliver_later
    end
  end
end
