require 'rails_helper'

RSpec.feature 'Scheduled appointment reminders' do
  scenario 'sends reminders for suitable appointments' do
    perform_enqueued_jobs do
      travel_to '2016-06-19 15:00' do
        given_suitable_and_unsuitable_appointments_exist
        when_the_reminder_job_runs
        then_the_email_reminder_is_delivered
        and_a_reminder_activity_is_logged
      end
    end
  end

  def given_suitable_and_unsuitable_appointments_exist
    @proceeded_at = Time.zone.parse('2016-06-20 12:00')

    @needing_reminder = create(:appointment, proceeded_at: @proceeded_at)

    @already_reminded = create(:appointment, proceeded_at: @proceeded_at) do |a|
      create(:reminder_activity, booking_request: a.booking_request)
    end
  end

  def when_the_reminder_job_runs
    AppointmentRemindersJob.new.perform
  end

  def then_the_email_reminder_is_delivered
    expect(ActionMailer::Base.deliveries.count).to eq(1)

    expect(ActionMailer::Base.deliveries.first.subject).to eq(
      'Your Pension Wise Appointment Reminder'
    )
  end

  def and_a_reminder_activity_is_logged
    expect(@needing_reminder.activities.first).to be_a(ReminderActivity)
  end
end
