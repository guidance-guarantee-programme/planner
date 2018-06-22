class BookingManagerSmsCancellationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    recipients = booking_managers(appointment)

    recipients.each do |recipient|
      Appointments.booking_manager_cancellation(recipient, appointment).deliver_later
    end
  end

  private

  def booking_managers(appointment)
    User.active.where(
      organisation_content_id: appointment.booking_request.booking_location_id
    )
  end
end
