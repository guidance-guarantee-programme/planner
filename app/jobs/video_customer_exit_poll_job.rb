class VideoCustomerExitPollJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless appointment.email?

    Appointments.video_customer_exit_poll(appointment).deliver_now

    VideoCustomerExitPollActivity.from(appointment)
  end
end
