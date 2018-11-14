# rubocop:disable MethodLength, AbcSize
require 'rails_helper'

RSpec.feature 'Agent places a realtime booking' do
  scenario 'Successfully placing a realtime booking/appointment' do
    travel_to '2018-11-03 13:00' do
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
    end
  end

  def given_the_user_identifies_as_an_agent
    create(:agent)
  end

  def and_available_realtime_slots_exist_within_the_booking_window
    create(:bookable_slot, :realtime, date: '2018-11-07')
    # a duplicate that gets deduplicated
    create(:bookable_slot, :realtime, date: '2018-11-07', guider_id: 2)
  end

  def when_they_attempt_to_place_a_booking_at_hackney
    @page = Pages::AgentBooking.new
    @page.load(location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end

  def and_they_choose_a_realtime_slot
    expect(@page).to be_displayed
    @page.first_choice_slot.select('Wednesday, 07 Nov - 9:00am')

    # only the primary slot is presented when realtime
    expect(@page).to have_no_second_choice_slot
    expect(@page).to have_no_third_choice_slot
  end

  def and_they_provide_the_customer_details
    @page.name.set('Summer Sanchez')
    @page.phone.set('07715 930 444')
    @page.memorable_word.set('spaceships')
    @page.date_of_birth.set('01/01/1950')
    @page.accessibility_requirements.set(true)
    @page.defined_contribution_pot_confirmed_yes.set(true)
    @page.gdpr_consent_yes.set(true)
    @page.where_you_heard.select('Other')
    @page.email.set('summer@example.com')
    @page.address_line_one.set('3 Grange View')
    @page.town.set('Reading')
    @page.county.set('Berkshire')
    @page.postcode.set('RG1 1AA')
    @page.additional_info.set('Other notes')
  end

  def and_they_confirm_the_booking
    @page.preview.click

    @page = Pages::AgentBookingPreview.new
    expect(@page).to be_displayed

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
      gdpr_consent: 'yes'
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
    assert_enqueued_jobs(2, only: [PrintedConfirmationLetterJob, AppointmentChangeNotificationJob])
  end
end
