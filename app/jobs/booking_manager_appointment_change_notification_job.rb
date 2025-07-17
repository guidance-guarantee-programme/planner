class BookingManagerAppointmentChangeNotificationJob < ActiveJob::Base
  queue_as :default

  include BookingManagerable

  def perform(appointment)
    booking_managers = booking_managers_for(appointment.booking_location_id)

    raise BookingManagersNotFoundError if booking_managers.blank?

    booking_managers.each do |booking_manager|
      Appointments.booking_manager_appointment_changed(
        appointment,
        booking_manager
      ).deliver_later
    end
  end
end
