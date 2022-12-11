require 'rails_helper'

RSpec.feature 'Agent cancels an appointment' do
  scenario 'Agent successfully cancels an appointment', js: true do
    given_the_user_identifies_as_an_agent_manager do
      and_an_appointment_exists
      when_the_agent_views_the_appointment
      and_they_cancel_the_appointment
      and_they_see_a_confirmation
      then_the_appointment_is_cancelled
      and_the_necessary_parties_are_notified
    end
  end

  def and_an_appointment_exists
    @appointment = create(:appointment)
  end

  def when_the_agent_views_the_appointment
    @page = Pages::AgentEditAppointment.new
    @page.load(id: @appointment.id)
  end

  def and_they_cancel_the_appointment
    @page.accept_confirm do
      @page.cancel.click
    end
  end

  def then_the_appointment_is_cancelled
    @appointment.reload

    expect(@appointment).to be_cancelled_by_customer
    expect(@appointment.secondary_status).to eq(Appointment::AGENT_PERMITTED_SECONDARY)
  end

  def and_they_see_a_confirmation
    expect(@page.success).to have_text('cancelled')
  end

  def and_the_necessary_parties_are_notified
    assert_enqueued_jobs(
      2,
      only: [AppointmentCancellationNotificationJob, BookingManagerAppointmentChangeNotificationJob]
    )
  end
end
