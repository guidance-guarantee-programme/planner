require 'rails_helper'

RSpec.feature 'Viewing Booking Requests' do
  scenario 'Booking manager views booking request slots' do
    given_the_user_identifies_as_hackneys_administrator do
      and_they_have_a_booking_with_multiple_slots
      when_they_visit_the_site
      then_they_see_the_correct_slot_ordering
    end
  end

  scenario 'Administrators can change their location' do
    given_the_user_identifies_as_hackneys_administrator do
      and_there_are_booking_requests_for_their_location
      when_they_visit_the_site
      then_they_are_shown_booking_requests_for_their_locations
      then_they_see_the_administrative_location_choices
    end
  end

  scenario 'Organisation admins can change their location' do
    given_the_user_identifies_as_an_organisation_admin do
      when_they_visit_the_site
      then_they_are_told_to_select_their_location
      then_they_see_the_administrative_location_choices
    end
  end

  scenario 'Bookings Manager views their Booking Requests' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_are_booking_requests_for_their_location
      when_they_visit_the_site
      then_they_are_shown_booking_requests_for_their_locations
      and_they_do_not_see_the_administrative_location_choices
      when_they_choose_to_show_hidden_booking_requests
      then_they_are_shown_hidden_booking_requests
      when_they_choose_to_show_active_booking_requests
      then_they_are_shown_booking_requests_for_their_locations
    end
  end

  scenario 'Searching Booking Requests' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_are_booking_requests_for_their_location
      when_they_search_by_booking_reference
      then_they_are_shown_the_booking_request_matching_the_reference
      when_they_search_by_customer_name
      then_they_are_shown_the_booking_requests_matching_the_customer_name
      when_they_filter_by_status
      then_they_are_shown_the_booking_request_matching_the_status
      when_they_filter_by_location
      then_they_are_shown_the_booking_request_matching_the_location
    end
  end

  def then_they_are_told_to_select_their_location
    @page = Pages::BookingRequests.new

    expect(@page).to be_displayed
    expect(@page).to have_booking_location_banner
  end

  def and_they_have_a_booking_with_multiple_slots
    @booking_request = create(:hackney_booking_request, number_of_slots: 3)
  end

  def then_they_see_the_correct_slot_ordering # rubocop:disable Metrics/AbcSize
    @page   = Pages::BookingRequests.new
    booking = @page.booking_requests.first

    expect(booking.primary_slot).to have_text(@booking_request.primary_slot)
    expect(booking.secondary_slot).to have_text(@booking_request.secondary_slot)
    expect(booking.tertiary_slot).to have_text(@booking_request.tertiary_slot)
  end

  def when_they_choose_to_show_hidden_booking_requests
    @page.search.status.select('Hidden')
    @page.search.submit.click
  end

  def then_they_are_shown_hidden_booking_requests
    expect(@page).to have_booking_requests(count: 1)
  end

  def when_they_choose_to_show_active_booking_requests
    @page.search.status.select('Active').click
    @page.search.submit.click
  end

  def and_they_do_not_see_the_administrative_location_choices
    expect(@page).to have_no_location
  end

  def then_they_see_the_administrative_location_choices
    expect(@page.location).to be_visible
  end

  def and_there_are_booking_requests_for_their_location # rubocop:disable Metrics/MethodLength
    @active_booking_requests = create_list(:hackney_booking_request, 8)
    @active_booking_requests << create(:hackney_booking_request, name: 'Morty Smith')
    @active_booking_requests << create(:hackney_booking_request, name: 'Jerry Smith')
    @active_booking_requests << create(
      :booking_request,
      name: 'Dalston Dave',
      booking_location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      location_id: '183080c6-642b-4b8f-96fd-891f5cd9f9c7'
    )

    # this won't be listed as it's not `active`
    create(:hackney_booking_request, name: 'Hidden Guy', status: :hidden)

    # this won't be listed as it's fulfilled
    create(:appointment)
  end

  def when_they_visit_the_site
    visit booking_requests_path
  end

  def then_they_are_shown_booking_requests_for_their_locations
    @page = Pages::BookingRequests.new
    expect(@page).to be_displayed
    expect(@page).to have_booking_requests(count: 10)
    expect(@page.booking_requests.first).to have_content('Hackney')
  end

  def when_they_search_by_booking_reference
    @page = Pages::BookingRequests.new.tap(&:load)
    expect(@page).to have_booking_requests(count: 10)

    @found_by_booking_reference = @active_booking_requests.first
    @page.search.reference.set(@found_by_booking_reference.id)
    @page.search.submit.click
  end

  def then_they_are_shown_the_booking_request_matching_the_reference
    expect(@page).to have_booking_requests(count: 1)
    expect(@page).to have_content(@found_by_booking_reference.name)
  end

  def when_they_search_by_customer_name
    @page.load

    @page.search.name.set('Smith')
    @page.search.submit.click
  end

  def then_they_are_shown_the_booking_requests_matching_the_customer_name
    expect(@page).to have_booking_requests(count: 2)
    expect(@page).to have_content('Morty Smith')
    expect(@page).to have_content('Jerry Smith')
  end

  def when_they_filter_by_status
    @page.load

    @page.search.status.select('Hidden')
    @page.search.submit.click
  end

  def then_they_are_shown_the_booking_request_matching_the_status
    expect(@page).to have_booking_requests(count: 1)
    expect(@page).to have_content('Hidden Guy')
  end

  def when_they_filter_by_location
    @page.load

    @page.search.location.select('Dalston')
    @page.search.submit.click
  end

  def then_they_are_shown_the_booking_request_matching_the_location
    expect(@page).to have_booking_requests(count: 1)
    expect(@page).to have_content('Dalston Dave')
  end
end
