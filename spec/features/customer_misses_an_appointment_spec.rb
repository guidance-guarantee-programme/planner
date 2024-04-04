require 'rails_helper'

RSpec.feature 'Customer misses an appointment' do
  scenario 'Agent marks the appointment as no show', js: true do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_an_appointment_exists
      when_they_view_the_appointment
      and_they_mark_the_appointment_as_no_show
      then_the_customer_is_notified
    end
  end

  def and_an_appointment_exists
    @appointment = create(:appointment)
  end

  def when_they_view_the_appointment
    @page = Pages::EditAppointment.new
    @page.load(id: @appointment.id)
  end

  def and_they_mark_the_appointment_as_no_show
    @page.status.select('No Show')
    @page.submit.click

    expect(@page).to have_success
  end

  def then_the_customer_is_notified
    assert_enqueued_jobs 1, only: AppointmentMissedNotificationJob
  end
end
