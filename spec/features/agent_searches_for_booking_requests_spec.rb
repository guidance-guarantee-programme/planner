require 'rails_helper'

RSpec.feature 'Agent searches for appointments' do
  scenario 'Searching via a given booking reference' do
    given_the_user_identifies_as_an_agent_manager
    and_appointments_exist
    when_they_visit_the_site
    and_search_for_a_particular_booking_reference
    then_they_see_the_appointment
    when_they_visit_the_site
    and_search_for_a_particular_customer
    then_they_see_the_customer_appointment
  end

  scenario 'Searching for booking requests' do
    given_the_user_identifies_as_an_agent_manager
    and_appointments_exist
    when_they_visit_the_site
    then_they_see_the_appointments
  end

  def and_search_for_a_particular_customer
    @page = Pages::AgentBookingSearch.new
    @page.customer.set('Mortimer')
    @page.submit.click
  end

  def then_they_see_the_customer_appointment
    expect(@page).to have_appointments(count: 1)
    expect(@page.appointments.first).to have_text('Mortimer Smith')
  end

  def given_the_user_identifies_as_an_agent_manager
    create(:agent_manager)
  end

  def and_appointments_exist
    # these will be returned
    @appointment = create(:appointment, :with_agent, guider_id: 2)
    # this will also be returned now since they're not just agent bookings
    create(:appointment, name: 'Mr Present')
  end

  def when_they_visit_the_site
    visit '/'
  end

  def then_they_see_the_appointments
    @page = Pages::AgentBookingSearch.new
    expect(@page).to be_displayed

    expect(@page).to have_appointments(count: 2)
    expect(@page).to have_text('Mr Present')
  end

  def and_search_for_a_particular_booking_reference
    @page = Pages::AgentBookingSearch.new
    @page.reference.set(@appointment.reference)
    @page.submit.click
  end

  def then_they_see_the_appointment
    expect(@page).to have_appointments(count: 1)
  end
end
