# rubocop:disable MethodLength, AbcSize
require 'rails_helper'

RSpec.feature 'Agent places a realtime booking' do
  scenario 'Seeing a descriptive failure message when unauthorised' do
    travel_to '2018-11-03 13:00' do
      given_the_user_identifies_as_a_resource_manager
      and_available_realtime_slots_exist_within_the_booking_window
      when_they_attempt_to_place_a_booking_at_hackney
      then_they_are_told_they_cannot_be_authorised
    end
  end

  scenario 'Successfully placing a realtime booking/appointment', js: true do
    travel_to '2018-11-01 13:00' do
      given_the_user_identifies_as_an_agent
      and_available_realtime_slots_exist_within_the_booking_window
      when_they_attempt_to_place_a_booking_at_hackney
      and_they_choose_a_realtime_slot
      and_they_provide_the_customer_details
      and_they_confirm_the_booking
      then_the_booking_is_placed
      and_the_appointment_is_automatically_fulfilled
      and_the_agent_sees_the_confirmation
      and_the_customer_is_notified
      and_the_booking_manager_is_notified
    end
  end

  def given_the_user_identifies_as_a_resource_manager
    create(:booking_manager)
  end

  def given_the_user_identifies_as_an_agent
    create(:agent)
  end

  def then_they_are_told_they_cannot_be_authorised
    expect(@page).to have_text('Please contact your Delivery Manager or MaPS')
  end

  def and_available_realtime_slots_exist_within_the_booking_window
    create(:bookable_slot, start_at: '2018-11-07 09:00', end_at: '2018-11-07 10:00')
    # a duplicate that gets deduplicated
    create(:bookable_slot, start_at: '2018-11-07 09:00', end_at: '2018-11-07 10:00', guider_id: 2)
  end

  def when_they_attempt_to_place_a_booking_at_hackney
    @page = Pages::AgentBooking.new
    @page.load(location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end

  def and_they_choose_a_realtime_slot
    expect(@page).to be_displayed
    @page.first_choice_slot.select('Wednesday, 07 Nov - 9:00am')
  end

  def and_they_provide_the_customer_details
    expect(@page).to have_text('Access via the lift is currently unavailable')

    @page.name.set('Summer Sanchez')
    @page.phone.set('07715 930 444')
    @page.memorable_word.set('spaceships')
    @page.date_of_birth.set('01/01/1950')
    @page.accessibility_requirements.set(true)
    @page.gdpr_consent_yes.set(true)
    @page.where_you_heard.select('Other')
    @page.email.set('summer@example.com')
    @page.address_line_one.set('3 Grange View')
    @page.town.set('Reading')
    @page.county.set('Berkshire')
    @page.postcode.set('RG1 1AA')
    @page.additional_info.set('Other notes')
    @page.recording_consent.set(true)
    @page.nudged.set(true)

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
  end

  def and_they_confirm_the_booking
    @page.preview.click

    @page = Pages::AgentBookingPreview.new
    expect(@page).to be_displayed
    expect(@page.first_choice_slot).to have_text('7 November 2018 - 09:00')

    @page.confirmation.click
  end

  def then_the_booking_is_placed
    @booking = BookingRequest.last
    expect(@booking).to have_attributes(
      name: 'Summer Sanchez',
      email: 'summer@example.com',
      phone: '07715 930 444',
      memorable_word: 'spaceships',
      date_of_birth: Date.parse('1950-01-01'),
      accessibility_requirements: true,
      defined_contribution_pot_confirmed: true,
      where_you_heard: 17, # Other
      address_line_one: '3 Grange View',
      town: 'Reading',
      county: 'Berkshire',
      postcode: 'RG1 1AA',
      age_range: '55-plus',
      additional_info: 'Other notes',
      gdpr_consent: 'yes',
      pension_provider: '',
      recording_consent: true,
      nudged: true,
      third_party: true,
      data_subject_name: 'Bob Bobson',
      data_subject_date_of_birth: '02/02/1980',
      email_consent_form_required: true,
      email_consent: 'bob@example.com',
      printed_consent_form_required: true,
      consent_address_line_one: '1 Some Street'
    )
  end

  def and_the_appointment_is_automatically_fulfilled
    @appointment = @booking.appointment

    expect(@appointment).to have_attributes(
      proceeded_at: Time.zone.parse('2018-11-07 09:00')
    )
  end

  def and_the_agent_sees_the_confirmation
    @page = Pages::AgentBookingConfirmation.new
    expect(@page).to be_displayed
  end

  def and_the_customer_is_notified
    assert_enqueued_jobs(
      4,
      only: [
        PrintedConfirmationLetterJob,
        AppointmentChangeNotificationJob,
        PrintedThirdPartyConsentFormJob,
        EmailThirdPartyConsentFormJob
      ]
    )
  end

  def and_the_booking_manager_is_notified
    assert_enqueued_jobs(1, only: BookingManagerConfirmationJob)
  end
end
