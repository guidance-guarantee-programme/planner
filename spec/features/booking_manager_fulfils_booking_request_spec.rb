# rubocop:disable Metrics/AbcSize
require 'rails_helper'

RSpec.feature 'Fulfiling Booking Requests' do
  scenario 'Bookings manager attempts to fulfil with a hidden location' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_unfulfilled_booking_request
      when_the_booking_manager_attempts_to_fulfil
      then_they_are_shown_the_fulfilment_page
      when_they_change_the_chosen_location_to_a_hidden_one
      and_they_submit_the_invalid_appointment
      then_they_see_the_validation_messages
    end
  end

  scenario 'Bookings Manager changes the state of a Booking Request', js: true do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_unfulfilled_booking_request
      when_the_booking_manager_attempts_to_fulfil
      then_they_are_shown_the_fulfilment_page
      when_they_choose_to_hide_the_booking_request
      then_the_booking_request_is_no_longer_active
      when_they_choose_to_activate_the_booking_request
      then_the_booking_request_is_now_active
      when_they_choose_to_mark_the_booking_awaiting_customer_feedback
      then_the_booking_request_is_now_awaiting_customer_feedback
      and_the_booking_request_has_associated_activation_activities
    end
  end

  scenario 'Bookings Manager fulfils a Booking Request' do
    perform_enqueued_jobs do
      travel_to '2016-06-19' do
        given_the_user_identifies_as_hackneys_booking_manager do
          and_there_is_an_unfulfilled_booking_request
          when_the_booking_manager_attempts_to_fulfil
          then_they_are_shown_the_fulfilment_page
          and_they_see_the_customer_details
          and_they_see_the_requested_slots
          when_they_choose_a_guider
          and_they_modify_the_customer_details
          and_the_location
          and_the_time_and_date_of_the_appointment
          then_the_appointment_is_created
          and_the_customer_is_notified
          and_the_booking_request_has_associated_audit_activity
        end
      end
    end
  end

  scenario 'Bookings Manager attempts to fulfil an invalid Appointment' do
    travel_to '2016-06-19' do
      given_the_user_identifies_as_hackneys_booking_manager do
        and_there_is_an_unfulfilled_booking_request
        when_the_booking_manager_attempts_to_fulfil
        then_they_are_shown_the_fulfilment_page
        when_they_submit_the_invalid_appointment
        then_they_see_the_validation_messages
      end
    end
  end

  def when_they_change_the_chosen_location_to_a_hidden_one
    @page.location.select('[HIDDEN] Enfield')
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

  def and_they_see_the_customer_details # rubocop:disable Metrics/MethodLength
    expect(@page.name.value).to eq(@booking_request.name)
    expect(@page.reference.text).to eq(@booking_request.reference)
    expect(@page.email.value).to eq(@booking_request.email)
    expect(@page.phone.value).to eq(@booking_request.phone)
    expect(@page.location_name.text).to eq('Hackney')
    expect(@page.memorable_word.value).to eq(@booking_request.memorable_word)
    expect(@page.day_of_birth.value).to eq(@booking_request.date_of_birth.day.to_s)
    expect(@page.month_of_birth.value).to eq(@booking_request.date_of_birth.month.to_s)
    expect(@page.year_of_birth.value).to eq(@booking_request.date_of_birth.year.to_s)
    expect(@page.defined_contribution_pot_confirmed_yes).to be_checked
    expect(@page.accessibility_requirements.value).to eq('1')
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

  def and_they_modify_the_customer_details
    @page.name.set 'Mortimer Sanchez'
    @page.email.set 'msanchez@example.com'
    @page.phone.set '01189 909 1234'
    @page.memorable_word.set 'stanky'
    @page.day_of_birth.set '02'
    @page.month_of_birth.set '02'
    @page.year_of_birth.set '1945'
    @page.defined_contribution_pot_confirmed_dont_know.set true
    @page.accessibility_requirements.set false
  end

  def and_the_location
    # ensure originally chosen location (Hackney) is selected
    expect(@page.location.value).to eq('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')

    # refine from Hackney
    @page.location.select('Tower Hamlets')
  end

  def and_the_time_and_date_of_the_appointment
    # ensure date defaults to primary slot date
    expect(@page.date.value).to eq(@booking_request.primary_slot.date.strftime('%d %B %Y'))
    # refine to 2016-06-20
    @page.advance_date!

    # ensure time defaults to primary slot time
    expect(@page.time).to eq('09:00')
    # refine time
    @page.set_time(hour: 15, minute: 30)
  end

  def then_the_appointment_is_created
    expect { @page.submit_appointment.click }.to change { Appointment.count }.by(1)

    expect(Appointment.first).to have_attributes(
      name: 'Mortimer Sanchez',
      email: 'msanchez@example.com',
      phone: '01189 909 1234',
      memorable_word: 'stanky',
      defined_contribution_pot_confirmed: false,
      accessibility_requirements: false,
      date_of_birth: Date.parse('1945-02-02')
    )
  end

  def and_the_customer_is_notified
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  def and_the_booking_request_has_associated_audit_activity
    expect(@booking_request.activities.count).to eq(1)
    expect(@booking_request.activities.first).to be_a(AppointmentMailActivity)
  end

  def when_they_submit_the_invalid_appointment
    @page.submit_appointment.click
  end
  alias_method :and_they_submit_the_invalid_appointment, :when_they_submit_the_invalid_appointment

  def then_they_see_the_validation_messages
    expect(@page).to have_error_summary
    expect(@page).to have_errors
  end

  def when_they_choose_to_hide_the_booking_request
    @page.change_booking_state.click
    @page.booking_request_hidden_status.click
    @page.submit_booking_request.click
  end

  def then_the_booking_request_is_no_longer_active
    @page = Pages::BookingRequests.new
    @page.load
    expect(@page).to have_no_booking_requests

    @page.search.status.select('Hidden')
    @page.search.submit.click
    expect(@page).to have_booking_requests
  end

  def when_they_choose_to_activate_the_booking_request
    @page.booking_requests.first.fulfil.click

    @page = Pages::FulfilBookingRequest.new
    @page.change_booking_state.click
    @page.booking_request_active_status.click
    @page.submit_booking_request.click
  end

  def then_the_booking_request_is_now_active
    @page = Pages::BookingRequests.new
    @page.load
    expect(@page).to have_booking_requests
  end

  def when_they_choose_to_mark_the_booking_awaiting_customer_feedback
    @page.booking_requests.first.fulfil.click

    @page = Pages::FulfilBookingRequest.new
    @page.change_booking_state.click
    @page.booking_request_awaiting_customer_status.click
    @page.submit_booking_request.click
  end

  def then_the_booking_request_is_now_awaiting_customer_feedback
    @page = Pages::BookingRequests.new
    @page.load
    expect(@page).to have_no_booking_requests

    @page.search.status.select('Awaiting Customer Feedback')
    @page.search.submit.click
    expect(@page).to have_booking_requests
  end

  def and_the_booking_request_has_associated_activation_activities
    expect(@booking_request.activities.count).to eq(3)
    expect(@booking_request.activities[0]).to be_a(ActivationActivity)
    expect(@booking_request.activities[1]).to be_a(ActivationActivity)
    expect(@booking_request.activities[2]).to be_a(ActivationActivity)
  end
end
