require 'rails_helper'

RSpec.feature 'Booking manager manages schedules' do
  scenario 'Viewing locations with default schedules' do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_they_view_their_schedules
      then_they_see_default_schedules_across_their_locations
    end
  end

  def when_they_view_their_schedules
    @page = Pages::Schedules.new
    @page.load
  end

  def then_they_see_default_schedules_across_their_locations
    expect(@page).to be_loaded

    expect(@page).to have_schedules(count: 6)
    expect(@page.schedules.first.location.text).to eq('Hackney')
  end
end
