# rubocop:disable Metrics/AbcSize
require 'rails_helper'

RSpec.feature 'Fulfiling Booking Requests' do
  scenario 'Bookings Manager fulfils a Booking Request' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_unfulfilled_booking_request
      when_the_booking_manager_attempts_to_fulfil
      then_they_are_shown_the_fulfilment_page
      and_they_see_the_customer_details
      and_they_see_the_requested_slots
      when_they_choose_a_guider
      and_the_time_and_date_of_the_appointment
      then_the_appointment_is_created
      and_the_customer_is_notified
    end
  end

  def and_there_is_an_unfulfilled_booking_request
    @booking_request = create(:hackney_booking_request)
  end

  def when_the_booking_manager_attempts_to_fulfil
    @page = Pages::BookingRequests.new
    @page.load

    @page.booking_requests.first.fulfil.click
  end

  def then_they_are_shown_the_fulfilment_page
    @page = Pages::FulfilBookingRequest.new
    expect(@page).to be_displayed
  end

  def and_they_see_the_customer_details
    expect(@page.name.text).to eq(@booking_request.name)
    expect(@page.reference.text).to eq(@booking_request.reference)
    expect(@page.email.text).to eq(@booking_request.email)
    expect(@page.location.text).to eq('Hackney')
    expect(@page.memorable_word.text).to eq(@booking_request.memorable_word)
    expect(@page.age_range.text).to eq(@booking_request.age_range)
  end

  def and_they_see_the_requested_slots
    expect(@page.slot_one_date.text).to eq(@booking_request.primary_slot.formatted_date)
    expect(@page.slot_one_period.text).to eq(@booking_request.primary_slot.period)

    expect(@page.slot_two_date.text).to eq(@booking_request.secondary_slot.formatted_date)
    expect(@page.slot_two_period.text).to eq(@booking_request.secondary_slot.period)

    expect(@page.slot_three_date.text).to eq(@booking_request.tertiary_slot.formatted_date)
    expect(@page.slot_three_period.text).to eq(@booking_request.tertiary_slot.period)
  end

  def when_they_choose_a_guider
    @page.guider.select('Ben Lovell')
  end

  def and_the_time_and_date_of_the_appointment
    skip
  end

  def then_the_appointment_is_created
    skip
  end

  def and_the_customer_is_notified
    skip
  end
end
