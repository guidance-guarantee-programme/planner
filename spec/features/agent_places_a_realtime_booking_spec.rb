# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
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
      and_the_agent_sees_the_confirmation
      then_the_booking_is_placed
      and_the_customer_is_notified
      and_the_booking_manager_is_notified
    end
  end

  def given_the_user_identifies_as_a_resource_manager
    create(:booking_manager)
  end

  def given_the_user_identifies_as_an_agent
    create(:agent_manager)
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
    @page.wait_until_adjustments_visible
    @page.adjustments.set('These adjustments.')
    @page.gdpr_consent_yes.set(true)
    @page.where_you_heard.select('Other')
    @page.email.set('summer@example.com')
    @page.address_line_one.set('3 Grange View')
    @page.town.set('Reading')
    @page.county.set('Berkshire')
    @page.postcode.set('RG1 1AA')
    @page.additional_info.set('Other notes')
    @page.nudged.set(true)
    @page.video_appointment.set(true)

    @page.third_party.set(true)
    @page.wait_until_data_subject_name_visible
    @page.data_subject_name.set('Bob Bobson')
    @page.data_subject_date_of_birth.set('02/02/1980')
    @page.data_subject_date_of_birth.send_keys(:return) # close date picker
  end

  def and_they_confirm_the_booking
    @page.preview.click

    @page = Pages::AgentBookingPreview.new
    expect(@page).to be_displayed
    expect(@page.first_choice_slot).to have_text('7 November 2018 - 09:00')

    @page.confirmation.click
  end

  def then_the_booking_is_placed
    @page = Pages::AgentBookingConfirmation.new
    expect(@page).to be_displayed

    @reference = @page.reference(visible: false).text(:all)
    @page = Pages::AgentEditAppointment.new
    @page.load(id: @reference)

    expect(@page.name.value).to eq('Summer Sanchez')
    expect(@page.email.value).to eq('summer@example.com')
    expect(@page.phone.value).to eq('07715 930 444')
    expect(@page.memorable_word.value).to eq('spaceships')
    expect(@page.day_of_birth.value).to eq('1')
    expect(@page.month_of_birth.value).to eq('1')
    expect(@page.year_of_birth.value).to eq('1950')
    expect(@page.accessibility_requirements).to be_checked
    expect(@page.adjustments.value).to eq('These adjustments.')
    expect(@page.defined_contribution_pot_confirmed_yes).to be_checked
    expect(@page.additional_information.value).to eq('Other notes')
    expect(@page.gdpr_consent_yes).to be_checked
    expect(@page.third_party).to be_checked
    expect(@page.data_subject_name.value).to eq('Bob Bobson')
    expect(@page.data_subject_date_of_birth.value).to eq('02/02/1980')
  end

  def and_the_agent_sees_the_confirmation
    @page = Pages::AgentBookingConfirmation.new
    expect(@page).to be_displayed
  end

  def and_the_customer_is_notified
    assert_enqueued_jobs(2, only: [PrintedConfirmationLetterJob, AppointmentChangeNotificationJob])
  end

  def and_the_booking_manager_is_notified
    assert_enqueued_jobs(1, only: BookingManagerConfirmationJob)
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
