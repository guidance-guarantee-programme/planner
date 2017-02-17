class AppointmentRemindersJob < ActiveJob::Base
  queue_as :default

  def perform
    Appointment.needing_reminder.each do |appointment|
      AppointmentReminderJob.perform_later(appointment)
    end
  end
end
