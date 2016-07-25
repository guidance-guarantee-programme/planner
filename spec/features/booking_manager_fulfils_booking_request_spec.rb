# rubocop:disable Metrics/AbcSize
require 'rails_helper'

RSpec.feature 'Fulfiling Booking Requests' do
  scenario 'Bookings Manager fulfils a Booking Request' do
    travel_to '2016-06-19' do
      given_the_user_identifies_as_hackneys_booking_manager do
        and_there_is_an_unfulfilled_booking_request
        when_the_booking_manager_attempts_to_fulfil
        then_they_are_shown_the_fulfilment_page
        and_they_see_the_customer_details
        and_they_see_the_requested_slots
        when_they_choose_a_guider
        and_the_location
        and_the_time_and_date_of_the_appointment
        then_the_appointment_is_created
        and_the_customer_is_notified
      end
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
    expect(@page.location_name.text).to eq('Hackney')
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

  def and_the_location
    # ensure originally chosen location (Hackney) is selected
    expect(@page.location.value).to eq('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')

    # refine from Hackney
    @page.location.select('Tower Hamlets')
  end

  def and_the_time_and_date_of_the_appointment
    # ensure date defaults to primary slot date
    expect(@page.date.value).to eq(@booking_request.primary_slot.date.to_s(:db))
    # refine to 2016-06-20
    @page.advance_date!

    # ensure time defaults to primary slot time
    expect(@page.time).to eq('09:00')
    # refine time
    @page.set_time(hour: 15, minute: 30)
  end

  def then_the_appointment_is_created
    expect { @page.submit.click }.to change { Appointment.count }.by(1)
  end

  def and_the_customer_is_notified
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
