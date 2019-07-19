class AppointmentCancellationNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless appointment.email?

    Appointments.cancellation(appointment).deliver

    AppointmentMailActivity.from(appointment)
  end
end
