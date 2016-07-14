require 'rails_helper'

RSpec.feature 'Viewing Booking Requests' do
  scenario 'Bookings Manager views their Booking Requests' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_are_booking_requests_for_their_location
      when_they_visit_the_site
      then_they_are_shown_booking_requests_for_their_locations
    end
  end

  def given_the_user_identifies_as_hackneys_booking_manager
    @user = create(:hackney_booking_manager)
    GDS::SSO.test_user = @user

    yield
  ensure
    GDS::SSO.test_user = nil
  end

  def and_there_are_booking_requests_for_their_location
    create(:hackney_booking_request)

    # this shouldn't be listed
    create(:booking_request)
  end

  def when_they_visit_the_site
    visit '/'
  end

  def then_they_are_shown_booking_requests_for_their_locations
    @page = Pages::BookingRequests.new
    expect(@page).to be_displayed
    expect(@page).to have_booking_requests(count: 1)
    expect(@page).to have_content('Hackney')
  end
end
