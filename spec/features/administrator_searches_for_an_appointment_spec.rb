require 'rails_helper'

RSpec.feature 'Administrator searches for an appointment', js: true do
  scenario 'Viewing as a less-privileged user' do
    given_the_user_identifies_as_hackneys_booking_manager do
      then_they_do_not_see_the_search_bar
    end
  end

  scenario 'Viewing an appointment', js: true do
    given_the_user_identifies_as_hackneys_administrator do
      when_they_search_for_an_appointment
      then_they_are_presented_with_the_appointment
    end
  end

  def when_they_search_for_an_appointment
    @appointment = create(:appointment)

    visit '/'
    find(:css, '.t-quick-search').click
    fill_in 'quick-search-input', with: @appointment.reference
    find(:css, '.t-quick-search-button').click
  end

  def then_they_are_presented_with_the_appointment
    expect(page.current_path).to eq(edit_appointment_path(@appointment))
  end

  def then_they_do_not_see_the_search_bar
    visit '/'

    expect(page).to have_no_css('.t-quick-search')
  end
end
