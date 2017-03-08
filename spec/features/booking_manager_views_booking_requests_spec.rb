require 'rails_helper'

RSpec.feature 'Viewing Booking Requests' do
  scenario 'Administrators can change their location' do
    given_the_user_identifies_as_hackneys_administrator do
      and_there_are_booking_requests_for_their_location
      when_they_visit_the_site
      then_they_are_shown_booking_requests_for_their_locations
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
      when_they_choose_to_hide_hidden_booking_requests
      then_they_are_shown_booking_requests_for_their_locations
    end
  end

  def when_they_choose_to_show_hidden_booking_requests
    @page.show_hidden_bookings.click
  end

  def then_they_are_shown_hidden_booking_requests
    expect(@page).to have_booking_requests(count: 1)
  end

  def when_they_choose_to_hide_hidden_booking_requests
    @page.hide_hidden_bookings.click
  end

  def and_they_do_not_see_the_administrative_location_choices
    expect(@page).to have_no_location
  end

  def then_they_see_the_administrative_location_choices
    expect(@page.location).to be_visible
  end

  def and_there_are_booking_requests_for_their_location
    create_list(:hackney_booking_request, 11)

    # this won't be listed as it's not `active`
    create(:hackney_booking_request, active: false)

    # this won't be listed as it's fulfilled
    create(:appointment)
  end

  def when_they_visit_the_site
    visit '/'
  end

  def then_they_are_shown_booking_requests_for_their_locations
    @page = Pages::BookingRequests.new
    expect(@page).to be_displayed
    expect(@page).to have_booking_requests(count: 10)
    expect(@page.booking_requests.first).to have_content('Hackney')
  end
end
