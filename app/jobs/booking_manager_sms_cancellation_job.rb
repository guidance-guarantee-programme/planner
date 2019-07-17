class BookingManagerSmsCancellationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    recipients = User.booking_managers(appointment.booking_request.booking_location_id)

    recipients.each do |recipient|
      Appointments.booking_manager_cancellation(recipient, appointment).deliver_later
    end
  end
end
