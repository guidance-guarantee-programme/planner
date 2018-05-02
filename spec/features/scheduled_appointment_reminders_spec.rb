require 'rails_helper'

RSpec.feature 'Scheduled appointment reminders' do
  scenario 'more than 48 hours before the appointment, it does not send a reminder' do
    perform_enqueued_jobs do
      travel_to Time.zone.parse('2016-06-17 11:55') do
        given_an_unreminded_appointment_exists
        when_the_reminder_job_runs
        then_no_email_reminder_is_delivered
        and_no_reminder_activity_is_logged
      end
    end
  end

  scenario 'within 48 hours of the appointment, it does send a reminder' do
    perform_enqueued_jobs do
      travel_to Time.zone.parse('2016-06-18 12:05') do
        given_an_unreminded_appointment_exists
        when_the_reminder_job_runs
        then_an_email_reminder_is_delivered
        and_a_reminder_activity_is_logged
      end
    end
  end

  scenario 'within 7 days of the appointment it does send a reminder' do
    perform_enqueued_jobs do
      travel_to Time.zone.parse('2016-06-13 12:05') do
        given_an_unreminded_appointment_exists
        when_the_reminder_job_runs
        then_an_email_reminder_is_delivered
        and_a_reminder_activity_is_logged
      end
    end
  end

  def given_an_unreminded_appointment_exists
    @proceeded_at = Time.zone.parse('2016-06-20 12:00')
    @appointment = create(:appointment, proceeded_at: @proceeded_at)
  end

  def when_the_reminder_job_runs
    AppointmentRemindersJob.new.perform
  end

  def then_no_email_reminder_is_delivered
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  def and_no_reminder_activity_is_logged
    expect(@appointment.activities).to be_empty
  end

  def and_no_additional_reminder_activity_is_logged
    expect(@appointment.activities.count).to eq(1)
  end

  def then_an_email_reminder_is_delivered
    expect(ActionMailer::Base.deliveries.count).to eq(1)

    expect(ActionMailer::Base.deliveries.first.subject)
      .to eq('Your Pension Wise Appointment Reminder')
  end

  def and_a_reminder_activity_is_logged
    expect(@appointment.activities.first).to be_a(ReminderActivity)
  end
end
