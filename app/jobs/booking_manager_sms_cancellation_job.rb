class BookingManagerSmsCancellationJob < ActiveJob::Base
  queue_as :default

  include BookingManagerable

  def perform(appointment)
    recipients = booking_managers_for(appointment.booking_request.booking_location_id)

    recipients.each do |recipient|
      Appointments.booking_manager_cancellation(recipient, appointment).deliver_later
    end
  end
end
