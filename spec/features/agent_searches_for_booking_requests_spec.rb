require 'rails_helper'

RSpec.feature 'Agent searches for booking requests' do
  scenario 'Searching via a given booking reference' do
    given_the_user_identifies_as_an_agent_manager
    and_booking_requests_exist
    when_they_visit_the_site
    and_search_for_a_particular_booking_reference
    then_they_see_the_booking_request
  end

  scenario 'Searching for booking requests' do
    given_the_user_identifies_as_an_agent_manager
    and_booking_requests_exist
    when_they_visit_the_site
    then_they_see_the_booking_requests
  end

  def given_the_user_identifies_as_an_agent_manager
    create(:agent_manager)
  end

  def and_booking_requests_exist
    # these will be returned
    @bookings = create_list(:hackney_booking_request, 3, agent: User.first)
    # this will be missing as it's not an agent booking
    create(:hackney_booking_request, name: 'Mr Missing')
  end

  def when_they_visit_the_site
    visit '/'
  end

  def then_they_see_the_booking_requests
    @page = Pages::AgentBookingSearch.new
    expect(@page).to be_displayed

    expect(@page).to have_booking_requests(count: 3)
    expect(@page).to have_no_text('Mr Missing')
  end

  def and_search_for_a_particular_booking_reference
    @page = Pages::AgentBookingSearch.new
    @page.reference.set(@bookings.first.id)
    @page.submit.click
  end

  def then_they_see_the_booking_request
    expect(@page).to have_booking_requests(count: 1)
  end
end
