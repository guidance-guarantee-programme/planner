# rubocop:disable MethodLength, AbcSize
require 'rails_helper'

RSpec.feature 'Agent places a booking request' do
  scenario 'Successfully placing a booking request' do
    travel_to '2017-11-14 13:00' do
      given_the_user_identifies_as_an_agent
      when_they_attempt_to_place_a_customer_booking_at_hackney
      and_they_choose_several_slots
      and_they_provide_the_customer_details
      and_they_confirm_the_booking
      then_the_booking_is_placed
      and_the_agent_sees_the_confirmation
    end
  end

  scenario 'Attempting to place an invalid booking request' do
    travel_to '2017-11-14 13:00' do
      given_the_user_identifies_as_an_agent
      when_they_attempt_to_place_a_customer_booking_at_hackney
      and_submit_the_request
      then_they_are_shown_validation_errors
    end
  end

  def and_submit_the_request
    @page.preview.click
  end

  def then_they_are_shown_validation_errors
    expect(@page).to have_errors
  end

  def given_the_user_identifies_as_an_agent
    create(:agent)
  end

  def when_they_attempt_to_place_a_customer_booking_at_hackney
    @page = Pages::AgentBooking.new
    @page.load(location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end

  def and_they_choose_several_slots
    expect(@page).to be_displayed

    @page.first_choice_slot.select('Friday, 17 Nov - Morning')
    @page.second_choice_slot.select('Friday, 17 Nov - Afternoon')
    @page.third_choice_slot.select('Friday, 01 Dec - Morning')
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

    expect(@booking.primary_slot.date).to eq('2017-11-17'.to_date)
    expect(@booking.secondary_slot.date).to eq('2017-11-17'.to_date)
    expect(@booking.tertiary_slot.date).to eq('2017-12-01'.to_date)
  end

  def and_the_agent_sees_the_confirmation
    @page = Pages::AgentBookingConfirmation.new
    expect(@page).to be_displayed
  end
end
