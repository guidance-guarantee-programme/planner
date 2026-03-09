class BslVideoCustomerExitPollJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless appointment.email?

    Appointments.bsl_video_customer_exit_poll(appointment).deliver_now

    BslVideoCustomerExitPollActivity.from(appointment)
  end
end
