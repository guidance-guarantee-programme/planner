require 'rails_helper'

RSpec.feature 'Booking manager manages schedules' do
  scenario 'Modifying a booking location’s schedules' do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_they_view_their_schedules
      then_they_see_default_schedules_across_their_locations
      when_they_manage_the_booking_location_schedule
      and_they_mark_some_days_unavailable
      when_they_save_the_schedule
      then_slot_generation_is_scheduled
      and_they_see_the_schedule_summarised_accurately
    end
  end

  def when_they_view_their_schedules
    @page = Pages::Schedules.new
    @page.load
  end

  def then_they_see_default_schedules_across_their_locations # rubocop:disable Metrics/AbcSize
    expect(@page).to be_loaded
    # Enfield is 'hidden' so will not be displayed
    expect(@page).to have_schedules(count: 5)

    # the booking location
    expect(@page.schedules.first.location.text).to eq('Hackney')
    expect(@page.schedules.first.manage['href']).to eq(
      new_schedule_path(location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
    )

    # the first child location
    expect(@page.schedules.second.location.text).to eq('Dalston')
    expect(@page.schedules.second.manage['href']).to eq(
      new_schedule_path(location_id: '183080c6-642b-4b8f-96fd-891f5cd9f9c7')
    )
  end

  def when_they_manage_the_booking_location_schedule
    @page.schedules.first.manage.click
  end

  def and_they_mark_some_days_unavailable
    @page = Pages::Schedule.new
    @page.load(location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
    expect(@page).to be_loaded

    @page.monday_am.click
    @page.wednesday_pm.click
    @page.friday_am.click
  end

  def when_they_save_the_schedule
    @page.submit.click
  end

  def then_slot_generation_is_scheduled
    assert_enqueued_jobs(1, only: SlotGenerationJob)
  end

  def and_they_see_the_schedule_summarised_accurately # rubocop:disable Metrics/AbcSize
    @page = Pages::Schedules.new

    @page.schedules.first.summary.tap do |summary|
      expect(summary.monday_am).to be_closed
      expect(summary.wednesday_pm).to be_closed
      expect(summary.friday_am).to be_closed
      # just a single example of an open slot
      expect(summary.monday_pm).to be_open
    end
  end
end