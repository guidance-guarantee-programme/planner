require 'rails_helper'

RSpec.feature 'Booking manager views appointments' do
  scenario 'Viewing a list of their associated appointments' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_are_appointments_for_their_location
      when_they_visit_the_appointments_list
      then_they_are_shown_appointments_for_their_location
    end
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
