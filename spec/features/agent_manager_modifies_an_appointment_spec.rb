require 'rails_helper'

RSpec.feature 'Agent manager modifies an appointment' do
  scenario 'Attempting to access as an agent' do
    given_the_user_identifies_as_an_agent do
      and_an_appointment_exists
      when_they_attempt_to_edit_an_appointment
      then_they_are_not_granted_access
    end
  end

  scenario 'Causing an error' do
    given_the_user_identifies_as_an_agent_manager do
      and_an_appointment_exists
      when_they_blank_the_name_field
      then_they_see_an_error_message
    end
  end

  scenario 'Successfully modifying an appointment', js: true do
    given_the_user_identifies_as_an_agent_manager do
      and_an_appointment_exists
      when_they_edit_the_appointment
      then_they_see_the_location
      and_the_appointment_is_modified
      and_the_customer_is_notified
      and_the_booking_managers_are_notified
      when_they_leave_an_activity_update
      then_the_activity_update_is_created
    end
  end

  scenario 'Resending an email confirmation' do
    given_the_user_identifies_as_an_agent_manager do
      and_an_appointment_exists
      when_they_view_the_appointment
      and_resend_an_email_confirmation
      then_the_email_confirmation_is_sent
    end
  end

  def when_they_leave_an_activity_update
    @page.activity_feed.message.set 'This is an update.'
    @page.activity_feed.submit.click
  end

  def then_the_activity_update_is_created
    @page.activity_feed.wait_until_activities_visible

    expect(@appointment.activities.first).to be_a(MessageActivity)
  end

  def when_they_view_the_appointment
    @page = Pages::AgentEditAppointment.new
    @page.load(id: @appointment.id)
  end

  def and_resend_an_email_confirmation
    @page.resend_confirmation.click
  end

  def then_the_email_confirmation_is_sent
    expect(@page.success).to have_text('re-sent successfully')
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

  def when_they_edit_the_appointment # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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
    @page.bsl_video.set(true)

    @page.third_party.set(true)

    @page.wait_until_data_subject_name_visible
    @page.data_subject_name.set('Bob Bobson')
    @page.data_subject_date_of_birth.set('02/02/1980')
    @page.data_subject_date_of_birth.send_keys(:return) # close date picker
    @page.email_consent_form_required.set(true)
    @page.wait_until_email_consent_visible
    @page.email_consent.set('bob@example.com')

    @page.printed_consent_form_required.set(true)
    @page.wait_until_consent_address_line_one_visible
    @page.consent_address_line_one.set('1 Some Street')
    @page.consent_address_line_two.set('Some Road')
    @page.consent_address_line_three.set('Some Place')
    @page.consent_address_town.set('Some Town')
    @page.consent_address_county.set('Some County')
    @page.consent_address_postcode.set('RM10 7BB')

    @page.submit.click
  end

  def then_they_see_the_location
    expect(@page.booking_location).to have_text('Hackney')
    expect(@page.location).to have_text('Hackney')
  end

  def and_the_appointment_is_modified
    expect(@page).to have_success

    @appointment.reload

    expect(@appointment.name).to include('Ben Lovell')
    expect(@appointment).to be_bsl_video
  end

  def and_the_customer_is_notified
    assert_enqueued_jobs(
      3,
      only: [
        AppointmentChangeNotificationJob,
        PrintedThirdPartyConsentFormJob,
        EmailThirdPartyConsentFormJob
      ]
    )
  end

  def and_the_booking_managers_are_notified
    assert_enqueued_jobs 1, only: BookingManagerAppointmentChangeNotificationJob
  end

  def when_they_attempt_to_edit_an_appointment
    @page = Pages::AgentEditAppointment.new
    @page.load(id: @appointment.id)
  end

  def then_they_are_not_granted_access
    expect(page.status_code).to eq(403)
  end
end
