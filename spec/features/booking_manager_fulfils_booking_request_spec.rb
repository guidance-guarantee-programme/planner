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
    skip
  end

  def and_they_see_the_requested_slots
    skip
  end

  def when_they_choose_a_guider
    skip
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
