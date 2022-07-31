require 'rails_helper'

RSpec.feature 'My Appointments calendar' do
  scenario 'A booking manager views their appointments', js: true do
    travel_to '2022-07-31 13:00' do
      given_the_user_identifies_as_hackneys_booking_manager do
        and_there_are_appointments_for_their_location
        when_they_view_the_calendar
        then_they_see_appointments_for_multiple_guiders
        when_they_filter_the_guiders
        then_they_see_an_appointment_for_the_guider
      end
    end
  end

  def and_there_are_appointments_for_their_location
    create(:appointment, name: 'George Smith', proceeded_at: Time.zone.parse('2022-08-01 08:30'))
    create(:appointment, name: 'Daisy Smith', proceeded_at: Time.zone.parse('2022-08-01 08:30'), guider_id: 2)
  end

  def when_they_view_the_calendar
    @page = Pages::Calendar.new
    @page.load
  end

  def then_they_see_appointments_for_multiple_guiders
    expect(@page).to have_events(count: 2)
    expect(@page.guiders).to match_array(['B Lovell', 'B Johnson', 'J Jones', 'J Smith'])
  end

  def when_they_filter_the_guiders
    @page.filter.click
    @page.wait_until_guider_search_visible
    @page.guider_search.send_keys('Ben L', :enter)
    @page.wait_until_chosen_guider_visible
  end

  def then_they_see_an_appointment_for_the_guider
    expect(@page.guiders).to match_array(['B Lovell'])
    expect(@page).to have_events(count: 1)
  end
end
