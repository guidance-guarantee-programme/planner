class BslCustomerExitPollJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless appointment.email?

    booking_location = BookingLocations.find(appointment.location_id)

    Appointments.bsl_customer_exit_poll(appointment, booking_location).deliver_now

    BslCustomerExitPollActivity.from(appointment)
  end
end
