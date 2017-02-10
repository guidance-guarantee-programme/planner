require 'rails_helper'

RSpec.feature 'Booking manager views appointments' do
  scenario 'Viewing a list of their associated appointments' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_are_appointments_for_their_location
      when_they_visit_the_appointments_list
      then_they_are_shown_appointments_for_their_location
    end
  end

  scenario 'Searching appointments' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_are_matching_appointments_for_their_location
      when_they_search_by_booking_reference
      then_they_are_shown_the_appointment_matching_the_reference
      when_they_search_by_customer_name
      then_they_are_shown_the_appointments_matching_the_customer_name
      when_they_filter_by_status
      then_they_are_shown_the_appointment_matching_the_status
      when_they_filter_by_location
      then_they_are_shown_the_appointment_matching_the_location
      when_they_filter_by_guider
      then_they_are_shown_the_appointment_matching_the_guider
    end
  end

  def when_they_filter_by_guider
    # reset the existing filters first
    @page.load

    @page.search.guider.select('Jenny Smith')
    @page.search.submit.click
  end

  def then_they_are_shown_the_appointment_matching_the_guider
    expect(@page).to have_appointments(count: 1)
    expect(@page).to have_content('Mrs Smith')
  end

  def when_they_filter_by_location
    # reset the existing filters first
    @page.load

    @page.search.location.select('Dalston')
    @page.search.submit.click
  end

  def then_they_are_shown_the_appointment_matching_the_location
    expect(@page).to have_appointments(count: 1)
    expect(@page).to have_content('Dalston Dave')
  end

  def when_they_filter_by_status
    @page.search.status.select('Completed')
    @page.search.submit.click
  end

  def then_they_are_shown_the_appointment_matching_the_status
    expect(@page).to have_appointments(count: 1)
  end

  def and_there_are_matching_appointments_for_their_location
    @found_by_location = create(
      :appointment,
      name: 'Dalston Dave',
      location_id: '183080c6-642b-4b8f-96fd-891f5cd9f9c7'
    )

    @found_by_guider            = create(:appointment, name: 'Mrs Smith', guider_id: 2)
    @found_by_booking_reference = create(:appointment, name: 'Mr Reference')
    @found_by_customer_name     = create(:appointment, name: 'Bob Bobson')
    @found_by_customer_name_and_status = create(:appointment, name: 'Bob Bobson', status: :completed)
  end

  def when_they_search_by_booking_reference
    @page = Pages::Appointments.new.tap(&:load)
    expect(@page).to have_appointments(count: 5)

    @page.search.search_term.set(@found_by_booking_reference.booking_request_id)
    @page.search.submit.click
  end

  def then_they_are_shown_the_appointment_matching_the_reference
    expect(@page).to have_appointments(count: 1)
    expect(@page).to have_content('Mr Reference')
  end

  def when_they_search_by_customer_name
    @page.search.search_term.set('Bobson')
    @page.search.submit.click
  end

  def then_they_are_shown_the_appointments_matching_the_customer_name
    expect(@page).to have_appointments(count: 2)
    expect(@page).to have_content('Bob Bobson')
  end

  def and_there_are_appointments_for_their_location
    create_list(:appointment, 11)

    # this won't be listed as it's not in Hackney
    create(:appointment, booking_request: create(:booking_request))
  end

  def when_they_visit_the_appointments_list
    visit '/appointments'
  end

  def then_they_are_shown_appointments_for_their_location
    @page = Pages::Appointments.new
    expect(@page).to be_displayed
    expect(@page).to have_appointments(count: 10)
    expect(@page).to have_content('Hackney')
  end
end
