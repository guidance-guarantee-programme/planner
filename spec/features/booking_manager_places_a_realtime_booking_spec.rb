# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
require 'rails_helper'

RSpec.feature 'Booking manager places a realtime booking', js: true do
  scenario 'Placing a Welsh language booking' do
    travel_to '2024-04-25 09:00' do
      given_the_user_identifies_as_cardiff_and_vales_booking_manager do
        and_cardiff_is_stubbed do
          and_available_slots_exist_for_cardiff
          when_they_attempt_to_book_with_cardiff
          and_they_confirm_the_booking_with_cardiff
          then_the_booking_is_placed_with_cardiff
        end
      end
    end
  end

  scenario 'Successfully placing an adhoc realtime booking' do
    travel_to '2019-11-28 13:00' do
      given_the_user_identifies_as_hackneys_booking_manager do
        when_they_search_with_a_hackney_postcode
        and_they_choose_an_adhoc_realtime_slot
        and_they_provide_the_customer_details
        and_they_confirm_the_ad_hoc_booking
        then_the_booking_is_placed
        and_the_appointment_is_automatically_fulfilled('2019-11-29 13:00')
        and_the_booking_manager_sees_the_confirmation
        and_the_customer_is_notified
        and_the_booking_manager_is_notified
      end
    end
  end

  scenario 'Successfully placing a scheduled realtime booking', js: true do
    travel_to '2018-11-01 13:00' do
      given_the_user_identifies_as_hackneys_booking_manager do
        and_available_realtime_slots_exist_within_the_booking_window
        when_they_search_with_a_hackney_postcode
        and_they_choose_a_realtime_slot
        and_they_provide_the_customer_details
        and_they_confirm_the_booking
        then_the_booking_is_placed
        and_the_appointment_is_automatically_fulfilled('2018-11-07 09:00')
        and_the_booking_manager_sees_the_confirmation
        and_the_customer_is_notified
        and_the_booking_manager_is_notified
      end
    end
  end

  def and_cardiff_is_stubbed
    stub_api = Class.new do
      def get(*)
        result = {
          'uid' => '525da418-ff2c-4522-90a9-bc70ba4ca78b',
          'name' => 'Cardiff & Vale',
          'locations' => [],
          'guiders' => [
            {
              'id': 99,
              'name': 'Daisy Lovell',
              'email': 'daisy@example.com'
            }
          ]
        }

        yield result
      end
    end

    current_api = BookingLocations.api
    BookingLocations.api = stub_api.new

    yield
  ensure
    BookingLocations.api = current_api
  end

  def and_available_slots_exist_for_cardiff
    @schedule = create(:schedule, :cardiff_and_vale)
    create(
      :bookable_slot,
      start_at: '2024-04-31 09:00',
      end_at: '2024-04-31 10:00',
      guider_id: 99,
      schedule: @schedule
    )
  end

  def when_they_attempt_to_book_with_cardiff
    @page = Pages::AdHocBooking.new
    @page.load(location_id: '525da418-ff2c-4522-90a9-bc70ba4ca78b')
    expect(@page).to be_loaded

    @page.availability_calendar.set(true)
    @page.first_choice_slot.select('Wednesday, 01 May - 9:00am')
    @page.name.set('Bob Bobwell')
    @page.phone.set('07715 930 444')
    @page.date_of_birth.set('01/01/1950')
    @page.date_of_birth.send_keys(:return) # close date picker
    @page.defined_contribution_pot_confirmed_yes.set(true)
    @page.gdpr_consent_yes.set(true)
    @page.where_you_heard.select('Other')
    @page.email.set('bob@example.com')
    @page.memorable_word.set('bloopers')
    @page.welsh.set(true)
    @page.preview.click
  end

  def and_they_confirm_the_booking_with_cardiff
    @page = Pages::AdHocBookingPreview.new
    expect(@page).to be_displayed
    @page.confirmation.click
  end

  def then_the_booking_is_placed_with_cardiff
    expect(Appointment.last).to be_welsh
  end

  def and_available_realtime_slots_exist_within_the_booking_window
    create(:bookable_slot, start_at: '2018-11-07 09:00', end_at: '2018-11-07 10:00')
    # a duplicate that gets deduplicated
    create(:bookable_slot, start_at: '2018-11-07 09:00', end_at: '2018-11-07 10:00', guider_id: 2)
  end

  def when_they_search_with_a_hackney_postcode
    @page = Pages::LocationSearch.new
    @page.load

    stub_hackney_postcode_search!

    @page.postcode.set('E3 3NN')
    @page.submit.click

    expect(@page).to have_locations
    expect(@page.locations.first.name).to have_text('Newham')
    expect(@page.locations.second.name).to have_text('Hackney')

    @page.locations.second.book.click
  end

  def and_they_choose_a_realtime_slot
    @page = Pages::AdHocBooking.new
    expect(@page).to be_loaded

    @page.availability_calendar.set(true)
    @page.wait_until_first_choice_slot_visible
    @page.first_choice_slot.select('Wednesday, 07 Nov - 9:00am')
  end

  def and_they_choose_an_adhoc_realtime_slot
    @page = Pages::AdHocBooking.new
    expect(@page).to be_loaded

    @page.ad_hoc_calendar.set(true)
    @page.wait_until_ad_hoc_start_at_visible
    @page.guider.select('Ben Lovell')
    @page.ad_hoc_start_at.set('2019-11-29 13:00')
  end

  def and_they_provide_the_customer_details
    expect(@page).to have_text('Access via the lift is currently unavailable')

    @page.name.set('Summer Sanchez')
    @page.phone.set('07715 930 444')
    @page.memorable_word.set('spaceships')
    @page.date_of_birth.set('01/01/1950')
    @page.accessibility_requirements.set(true)
    @page.wait_until_adjustments_visible
    @page.adjustments.set('Their adjustments')
    @page.defined_contribution_pot_confirmed_yes.set(true)
    @page.gdpr_consent_yes.set(true)
    @page.where_you_heard.select('Other')
    @page.email.set('summer@example.com')
    @page.address_line_one.set('3 Grange View')
    @page.town.set('Reading')
    @page.county.set('Berkshire')
    @page.postcode.set('RG1 1AA')
    @page.additional_info.set('Other notes')
    @page.bsl.set(true)
    @page.third_party.set(true)

    expect(@page).not_to have_welsh

    @page.wait_until_data_subject_name_visible
    @page.data_subject_name.set('Bob Bobson')
    @page.data_subject_date_of_birth.set('02/02/1980')
    @page.data_subject_date_of_birth.send_keys(:return) # close date picker
  end

  def and_they_confirm_the_booking
    @page.preview.click

    @page = Pages::AdHocBookingPreview.new
    expect(@page).to be_displayed
    expect(@page).to have_no_guider
    expect(@page.first_choice_slot).to have_text('7 November 2018 - 09:00')

    @page.confirmation.click
  end

  def and_they_confirm_the_ad_hoc_booking
    @page.preview.click

    @page = Pages::AdHocBookingPreview.new
    expect(@page).to be_displayed
    expect(@page.guider).to have_text('Ben Lovell')
    expect(@page.first_choice_slot).to have_text('1:00pm, 29 November 2019')

    @page.confirmation.click
  end

  def then_the_booking_is_placed
    @page = Pages::AppointmentConfirmation.new
    expect(@page).to be_displayed

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
      third_party: true,
      bsl: true,
      adjustments: 'Their adjustments'
    )
  end

  def and_the_appointment_is_automatically_fulfilled(time)
    @appointment = @booking.appointment

    expect(@appointment).to have_attributes(proceeded_at: Time.zone.parse(time))
  end

  def and_the_booking_manager_sees_the_confirmation
    @page = Pages::AgentBookingConfirmation.new
    expect(@page).to be_loaded
  end

  def and_the_customer_is_notified
    assert_enqueued_jobs(2, only: [PrintedConfirmationLetterJob, AppointmentChangeNotificationJob])
  end

  def and_the_booking_manager_is_notified
    assert_enqueued_jobs(1, only: BookingManagerConfirmationJob)
  end
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize
