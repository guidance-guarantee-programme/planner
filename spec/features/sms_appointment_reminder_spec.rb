require 'rails_helper'

RSpec.feature 'SMS appointment reminders' do
  scenario 'Executing the SMS appointment reminders job' do
    travel_to '2018-05-28 08:00 UTC' do
      given_appointments_due_sms_reminders_exist
      when_the_task_is_executed
      then_the_required_jobs_are_scheduled
    end
  end

  def given_appointments_due_sms_reminders_exist # rubocop:disable Metrics/AbcSize
    # on the same day so excluded
    @same_day = create(:appointment, proceeded_at: 2.days.from_now, guider_id: 2)
    # past the reminder window
    @past = create(:appointment, proceeded_at: 5.days.from_now, created_at: 1.day.ago, guider_id: 2)
    # in the window but no mobile number
    @no_mobile = create(:appointment, phone: '02082524727', proceeded_at: 2.days.from_now, created_at: 1.day.ago)
    # in the window with a mobile number
    @mobile = create(
      :appointment,
      phone: '07715930455',
      proceeded_at: 3.days.from_now,
      created_at: 1.day.ago,
      guider_id: 3
    )
    # in the 7 day window with a mobile number
    @seven_day = create(:appointment, phone: '07715930455', proceeded_at: 7.days.from_now, created_at: 1.day.ago)
  end

  def when_the_task_is_executed
    SmsAppointmentRemindersJob.perform_now
  end

  def then_the_required_jobs_are_scheduled
    assert_enqueued_jobs(2, only: SmsAppointmentReminderJob)
  end
end
