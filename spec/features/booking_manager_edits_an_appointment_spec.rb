# rubocop:disable Metrics/AbcSize
require 'rails_helper'

RSpec.feature 'Booking Manager edits an Appointment' do
  scenario 'Processing an appointment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment
      when_the_booking_manager_edits_the_appointment
      and_processes_the_appointment
      then_the_appointment_is_processed
    end
  end

  scenario 'Rescheduling a realtime appointment', js: true do
    travel_to '2018-11-11 13:00' do
      given_the_user_identifies_as_hackneys_booking_manager do
        and_there_is_a_realtime_appointment
        and_available_realtime_slots_exist
        when_the_booking_manager_edits_the_appointment
        and_reschedules_the_appointment
        then_the_appointment_is_rescheduled
      end
    end
  end

  scenario 'Altering consent on an appointment', js: true do
    travel_to '2018-11-11 13:00' do
      given_the_user_identifies_as_hackneys_booking_manager do
        and_there_is_a_realtime_appointment
        when_the_booking_manager_edits_the_appointment
        and_alters_the_customer_research_consent
        then_the_appointment_consent_is_updated
      end
    end
  end

  scenario 'Resending the appointment confirmation', js: true do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment
      when_the_booking_manager_edits_the_appointment
      then_the_appointment_details_are_presented
      when_they_resend_the_confirmation
      then_the_confirmation_is_sent
    end
  end

  scenario 'Viewing the full changes as a booking manager' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment_with_changes
      when_they_view_the_changes
      then_the_full_changes_are_presented
    end
  end

  scenario 'Viewing changes as an agent manager' do
    given_the_user_identifies_as_an_agent_manager do
      and_there_is_an_appointment_with_changes
      when_they_view_the_changes_page_for_the_appointment
      then_the_full_changes_are_presented
    end
  end

  scenario 'Appointment with duplicates' do
    travel_to '2016-01-01' do # ensure appointment has not elapsed
      given_the_user_identifies_as_hackneys_booking_manager do
        and_there_is_an_appointment
        and_the_appointment_is_duplicated
        when_the_booking_manager_edits_the_appointment
        then_they_see_the_duplicate
      end
    end
  end

  scenario 'Successfully editing an Appointment', js: true do
    perform_enqueued_jobs do
      travel_to '2016-01-01' do # ensure appointment has not elapsed
        given_the_user_identifies_as_hackneys_booking_manager do
          and_there_is_an_appointment
          when_the_booking_manager_edits_the_appointment
          then_the_appointment_details_are_presented
          and_they_see_the_requested_slots
          when_they_modify_the_appointment_details
          then_the_appointment_is_updated
          and_the_customer_is_notified_correctly
          and_the_booking_request_has_associated_audit_and_mail_activity
        end
      end
    end
  end

  scenario 'Editing an Appointment causes validation failures' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment
      when_the_booking_manager_edits_the_appointment
      and_provides_invalid_information
      then_they_see_the_validation_messages
    end
  end

  scenario 'Update the status of an Appointment', js: true do
    perform_enqueued_jobs do
      given_the_user_identifies_as_hackneys_booking_manager do
        and_there_is_an_appointment
        when_the_booking_manager_edits_the_appointment
        then_they_see_the_original_status
        when_they_modify_the_status
        then_the_status_is_updated
        and_the_customer_is_notified
      end
    end
  end

  scenario 'Cancelling an appointment triggers the correct email', js: true do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment
      when_the_booking_manager_edits_the_appointment
      and_cancels_for_the_customer
      then_the_customer_receives_the_cancellation_email
    end
  end

  def and_cancels_for_the_customer
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    @page.status.select('Cancelled By Customer')
    @page.wait_until_secondary_status_options_visible
    @page.secondary_status.select('Customer changed their mind')

    @page.submit.click
  end

  def then_the_customer_receives_the_cancellation_email
    expect(@page).to have_success

    assert_enqueued_jobs(1, only: AppointmentCancellationNotificationJob)
  end

  def and_processes_the_appointment
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    @page.process.click
  end

  def then_the_appointment_is_processed
    expect(@page).to have_success
  end

  def and_there_is_a_realtime_appointment
    @slot    = create(:bookable_slot, start_at: '2018-11-15 09:00')
    @booking = build(:hackney_booking_request, number_of_slots: 0)
    @booking.slots.build(date: '2018-11-15', from: '0900', to: '1000', priority: 1)

    @appointment = create(:appointment, booking_request: @booking, proceeded_at: @slot.start_at)
  end

  def and_available_realtime_slots_exist
    @slot = create(:bookable_slot, start_at: '2018-11-16 09:00', guider_id: 2, schedule: @slot.schedule)
  end

  def and_reschedules_the_appointment
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    @page.reschedule.click
    @page.wait_until_rescheduling_modal_visible

    @page.rescheduling_modal.slot.select('Friday, 16 Nov - 9:00am')
    @page.rescheduling_modal.reschedule.click
  end

  def and_alters_the_customer_research_consent
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    @page.consent.click
    @page.wait_until_consent_modal_visible

    @page.consent_modal.consent_yes.set(true)
    @page.consent_modal.update.click
  end

  def then_the_appointment_consent_is_updated
    @page.wait_until_consent_modal_invisible
    expect(@page).to have_text('The customer research consent was updated')
  end

  def then_the_appointment_is_rescheduled
    @page.wait_until_rescheduling_modal_invisible
    expect(@page).to have_text('The appointment was rescheduled')

    expect(@appointment.reload).to have_attributes(
      proceeded_at: @slot.start_at,
      guider_id: @slot.guider_id
    )
  end

  def when_they_resend_the_confirmation
    @page.accept_confirm do
      @page.resend_confirmation.click
    end
  end

  def then_the_confirmation_is_sent
    expect(@page).to have_success

    assert_enqueued_jobs(1, only: AppointmentChangeNotificationJob)
  end

  def and_there_is_an_appointment_with_changes
    @appointment = create(:appointment)

    @appointment.update(
      name: 'Morty Smith',
      memorable_word: 'hamburgers',
      location_id: '183080c6-642b-4b8f-96fd-891f5cd9f9c7',
      guider_id: 2,
      status: :completed
    )
  end

  def when_they_view_the_changes
    @page = Pages::EditAppointment.new
    @page.load(id: @appointment.id)

    @page.activity_feed.activities.first.changes.click
  end

  def when_they_view_the_changes_page_for_the_appointment
    @page = Pages::Changes.new
    @page.load(id: @appointment.id)
  end

  def then_the_full_changes_are_presented
    @page = Pages::Changes.new
    expect(@page).to be_displayed

    verify_row(0, 'Name', 'Mortimer Smith', 'Morty Smith')
    verify_row(1, 'Guider', 'Ben Lovell', 'Jenny Smith')
    verify_row(2, 'Location', 'Hackney', 'Dalston')
    verify_row(3, 'Status', 'Pending', 'Completed')
    verify_row(4, 'Memorable word', 'spaceships', 'hamburgers')
  end

  def verify_row(index, label, before, after)
    @page.rows[index].tap do |row|
      expect(row.label.text).to  eq(label)
      expect(row.before.text).to eq(before)
      expect(row.after.text).to  eq(after)
    end
  end

  def and_there_is_an_appointment
    @appointment = create(
      :appointment,
      booking_request: build(:hackney_booking_request, number_of_slots: 3)
    )
  end

  def and_the_appointment_is_duplicated
    @duplicate = create(
      :appointment,
      guider_id: 2,
      booking_request: build(:hackney_booking_request, number_of_slots: 1)
    )
  end

  def then_they_see_the_duplicate
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page).to have_duplicates
    expect(@page.duplicates.first).to have_text(@duplicate.reference)
  end

  def when_the_booking_manager_edits_the_appointment
    @page = Pages::Appointments.new
    @page.load
    @page.appointments.first.edit.click
  end

  def then_the_appointment_details_are_presented
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page).to have_text('Access via the lift is currently unavailable')

    expect(@page.name.value).to eq(@appointment.name)
    expect(@page.email.value).to eq(@appointment.email)
    expect(@page.phone.value).to eq(@appointment.phone)
    expect(@page.memorable_word.value).to eq(@appointment.memorable_word)
    expect(@page.day_of_birth.value).to eq(@appointment.date_of_birth.day.to_s)
    expect(@page.month_of_birth.value).to eq(@appointment.date_of_birth.month.to_s)
    expect(@page.year_of_birth.value).to eq(@appointment.date_of_birth.year.to_s)
    expect(@page.defined_contribution_pot_confirmed_yes).to be_checked
    expect(@page.accessibility_requirements.value).to eq('1')
    expect(@page.gdpr_consent).to have_text('Yes')

    # ensure Hackney is pre-selected
    expect(@page.location.value).to eq('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')

    expect(@page.date.value).to eq('20/06/2016')
    expect(@page.time_hour.value).to eq('14')
    expect(@page.time_minute.value).to eq('00')
  end

  def and_they_see_the_requested_slots
    @booking_request = @appointment.booking_request

    expect(@page.slot_one_date.text).to eq(@booking_request.primary_slot.formatted_date)
    expect(@page.slot_one_period.text).to eq(@booking_request.primary_slot.period)

    expect(@page.slot_two_date.text).to eq(@booking_request.secondary_slot.formatted_date)
    expect(@page.slot_two_period.text).to eq(@booking_request.secondary_slot.period)

    expect(@page.slot_three_date.text).to eq(@booking_request.tertiary_slot.formatted_date)
    expect(@page.slot_three_period.text).to eq(@booking_request.tertiary_slot.period)
  end

  def when_they_modify_the_appointment_details
    @page.name.set('Bob Jones')
    @page.email.set('bob@example.com')
    @page.phone.set('01189 888 888')
    @page.memorable_word.set('snarf')
    @page.day_of_birth.set('02')
    @page.month_of_birth.set('02')
    @page.year_of_birth.set('1945')
    @page.defined_contribution_pot_confirmed_dont_know.set true
    @page.accessibility_requirements.set(false)
    @page.date.set('21/06/2016')
    @page.time_hour.select('15')
    @page.time_minute.select('15')
    @page.guider.select('Bob Johnson')
    @page.bsl.set(true)
    @page.third_party.set(true)
    @page.attended_digital_yes.set(true)

    @page.wait_until_data_subject_name_visible
    @page.data_subject_name.set('Bob Bobson')
    @page.data_subject_date_of_birth.set('02/02/1980')
    @page.data_subject_date_of_birth.send_keys(:return) # close date picker

    @page.submit.click
  end

  def then_the_appointment_is_updated
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed
    expect(@page.name.value).to eq 'Bob Jones'
    expect(@page.date.value).to eq '21/06/2016'
    expect(@page.time_hour.value).to eq '15'
    expect(@page.time_minute.value).to eq '15'
    expect(@page.guider.find('option', text: 'Bob Johnson').selected?).to eq true
    expect(@page.bsl).to be_checked
    expect(@page.attended_digital_yes).to be_selected
  end

  def and_the_customer_is_notified
    expect(ActionMailer::Base.deliveries.count).to eq(1)
    expect(ActionMailer::Base.deliveries.first.subject).to eq('Your Pension Wise Appointment Cancellation')
  end

  def and_the_customer_is_notified_correctly
    expect(ActionMailer::Base.deliveries.map(&:subject)).to include(
      'Your Pension Wise Appointment'
    )
  end

  def and_the_customer_is_not_notified
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  def and_the_booking_request_has_associated_audit_and_mail_activity
    expect(@booking_request.activities.count).to eq(2)
    expect(@booking_request.activities.map(&:class)).to include(
      AppointmentMailActivity,
      AuditActivity
    )
  end

  def then_they_see_the_original_status
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page.status.value).to eq 'pending'
  end

  def when_they_modify_the_status
    @page.status.select('Cancelled By Customer')
    @page.wait_until_secondary_status_options_visible
    @page.secondary_status.select('Cancelled prior to appointment')
    @page.submit.click
  end

  def then_the_status_is_updated
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page.status.value).to eq 'cancelled_by_customer'
    expect(@page.secondary_status.value).to eq '15'
  end

  def and_provides_invalid_information
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    @page.name.set('')
    @page.email.set('')
    @page.phone.set('')

    @page.submit.click
  end

  def then_they_see_the_validation_messages
    expect(@page).to have_error_summary
    expect(@page).to have_errors
  end
end
# rubocop:enable Metrics/AbcSize
