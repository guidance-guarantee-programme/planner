require 'rails_helper'

RSpec.feature 'Scheduled reporting summary' do
  scenario 'Generating daily statistics per booking enabled location' do
    travel_to '2018-04-20 10:00' do
      given_several_booking_locations_exist do
        and_the_booking_locations_have_schedules_of_varying_availability
        when_the_task_runs
        then_the_correct_daily_statistics_are_persisted
      end
    end
  end

  def given_several_booking_locations_exist # rubocop:disable Metrics/MethodLength
    current_api = BookingLocations.api
    BookingLocations.api = Class.new do
      def all
        [
          { 'uid' => '108cac82-16ec-41f0-8177-e55019e8c110', 'title' => 'Abergavenny' },
          { 'uid' => '377e27e1-8f38-437a-baa9-4e90ebd980e8', 'title' => 'Hackney' },
          { 'uid' => '47b30a8f-d5f9-448e-a7ac-d5397a853e6a', 'title' => 'Reading' }
        ]
      end
    end.new

    yield
  ensure
    BookingLocations.api = current_api
  end

  def and_the_booking_locations_have_schedules_of_varying_availability
    # Unavailable
    create(:schedule, location_id: '108cac82-16ec-41f0-8177-e55019e8c110')

    # Limited availability
    create(:schedule, location_id: '377e27e1-8f38-437a-baa9-4e90ebd980e8') do |schedule|
      create(:bookable_slot, schedule: schedule, start_at: '2018-04-27 10:00')
    end

    # Only available after the 4 week window
    create(:schedule, location_id: '47b30a8f-d5f9-448e-a7ac-d5397a853e6a') do |schedule|
      create(:bookable_slot, schedule: schedule, start_at: '2018-05-25 10:00')
    end
  end

  def when_the_task_runs
    ScheduledReportingSummary.new.call
  end

  def then_the_correct_daily_statistics_are_persisted # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @summaries = ReportingSummary.all

    expect(@summaries.first).to have_attributes(
      name: 'Abergavenny',
      four_week_availability: false,
      first_available_slot_on: nil,
      created_at: Time.zone.now
    )

    expect(@summaries.second).to have_attributes(
      name: 'Hackney',
      four_week_availability: true,
      first_available_slot_on: '2018-04-27'.to_date,
      created_at: Time.zone.now
    )

    expect(@summaries.third).to have_attributes(
      name: 'Reading',
      four_week_availability: false,
      first_available_slot_on: '2018-05-25'.to_date,
      created_at: Time.zone.now
    )
  end
end
