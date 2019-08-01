require 'rails_helper'

RSpec.feature 'Agent modifies an appointment' do
  scenario 'Causing an error' do
    given_the_user_identifies_as_an_agent do
      and_an_appointment_exists
      when_they_blank_the_name_field
      then_they_see_an_error_message
    end
  end

  scenario 'Successfully modifying an appointment' do
    given_the_user_identifies_as_an_agent do
      and_an_appointment_exists
      when_they_edit_the_appointment
      then_they_see_the_location
      and_the_appointment_is_modified
      and_the_customer_is_notified
    end
  end

  def when_they_blank_the_name_field
    @page = Pages::AgentEditAppointment.new
    @page.load(id: @appointment.id)

    @page.name.set('')
    @page.submit.click
  end

  def then_they_see_an_error_message
    expect(@page).to have_errors
  end

  def and_an_appointment_exists
    @appointment = create(:appointment, proceeded_at: 3.weeks.from_now)
  end

  def when_they_edit_the_appointment # rubocop:disable MethodLength, AbcSize
    @page = Pages::AgentEditAppointment.new
    @page.load(id: @appointment.id)

    @page.name.set('Ben Lovell')
    @page.email.set('ben@example.com')
    @page.phone.set('07715 930 459')
    @page.day_of_birth.set('02')
    @page.month_of_birth.set('02')
    @page.year_of_birth.set('1960')
    @page.accessibility_requirements.set(true)
    @page.additional_information.set('Blah, blah, blah.')
    @page.defined_contribution_pot_confirmed_dont_know.set(true)

    @page.submit.click
  end

  def then_they_see_the_location
    expect(@page.location).to have_text('Hackney')
  end

  def and_the_appointment_is_modified
    expect(@page).to have_success

    @appointment.reload

    expect(@appointment.name).to eq('Ben Lovell')
  end

  def and_the_customer_is_notified
    assert_enqueued_jobs 1, only: AppointmentChangeNotificationJob
  end
end
