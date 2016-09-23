require 'rails_helper'

RSpec.feature 'Booking manager views the appointments calendar', js: true do
  scenario 'Viewing the appointments' do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2016-06-19' do
        and_there_are_appointments_for_their_locations
        when_they_visit_the_appointments_calendar
        then_they_are_shown_their_guiders
        and_they_are_shown_their_locations
        and_they_are_shown_appointments_for_their_location
      end
    end
  end

  def and_there_are_appointments_for_their_locations
    @hackney  = BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
    @dalston  = @hackney.location_for('183080c6-642b-4b8f-96fd-891f5cd9f9c7')
    @haringey = @hackney.location_for('c165d25e-f27b-4ce9-b3d3-e7415ebaa93c')
    @ben = 1
    @jen = 2

    # Hackney, Ben Lovell
    create(:appointment)
    # Dalston, Ben Lovell
    create(:appointment, location_id: @dalston.id)

    # Hackney, Jenny Smith
    create(:appointment, guider_id: @jen)
    # Haringey, Jenny Smith
    create(:appointment, location_id: @haringey.id, guider_id: @jen)
  end

  def when_they_visit_the_appointments_calendar
    @page = Pages::Calendar.new
    @page.load
  end

  def then_they_are_shown_their_guiders
    skip
  end

  def and_they_are_shown_their_locations
    skip
  end

  def then_they_are_shown_appointments_for_their_location
    skip
  end
end
