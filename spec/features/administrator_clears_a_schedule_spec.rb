require 'rails_helper'

RSpec.feature 'Administrator clears a schedule' do
  scenario 'Successfully clearing a schedule of future slots', js: true do
    given_the_user_identifies_as_hackneys_administrator do
      travel_to '2020-01-31 13:00' do
        and_a_schedule_exists
        when_they_view_their_schedules
        and_choose_to_clear_a_schedule
        then_the_future_slots_are_cleared
      end
    end
  end

  def and_a_schedule_exists
    @schedule = create(:schedule)
    # this will not be deleted
    @remained = create(:bookable_slot, start_at: '2020-01-30 13:00', schedule: @schedule)
    # this will be deleted
    @deleted = create(:bookable_slot, start_at: '2020-02-03 13:00', schedule: @schedule)
  end

  def when_they_view_their_schedules
    @page = Pages::Schedules.new
    @page.load
  end

  def and_choose_to_clear_a_schedule
    expect(@page).to have_schedules

    @page.accept_confirm do
      # Hackney
      @page.schedules.first.clear_future_slots.click
    end
  end

  def then_the_future_slots_are_cleared
    expect(@page).to have_success

    expect(@schedule.bookable_slots.pluck(:start_at).map(&:to_date)).to eq(['2020-01-30'.to_date])
  end
end
