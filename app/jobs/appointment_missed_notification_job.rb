class AppointmentMissedNotificationJob < ActiveJob::Base
  queue_as :default

  def perform(appointment)
    return unless appointment.email?

    Appointments.missed(appointment).deliver

    AppointmentMailActivity.from(appointment)
  end
end
