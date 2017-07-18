require 'rails_helper'

RSpec.describe 'GET /api/v1/locations/{location_id}/bookable_slots' do
  scenario 'Returns real availability for locations with schedules' do
    travel_to '2017-05-26 13:00' do
      given_a_location_with_a_schedule_exists
      when_a_request_for_the_location_is_made
      then_the_service_responds_ok
      and_slots_are_serialized_as_json
      and_the_correct_slots_are_returned
    end
  end

  scenario 'Returns default availability for locations without schedules' do
    when_a_request_for_a_location_without_a_schedule_is_made
    then_the_service_responds_ok
    and_slots_are_serialized_as_json
  end

  def given_a_location_with_a_schedule_exists
    @schedule = create(:schedule).tap do |schedule|
      # excluded due to falling within the grace period
      create(:bookable_slot, :am, schedule: schedule)
      # excluded as after booking window
      create(:bookable_slot, :am, schedule: schedule, date: 7.weeks.from_now)
      # will be returned
      create(:bookable_slot, :am, schedule: schedule, date: GracePeriod.new.call)
    end
  end

  def when_a_request_for_the_location_is_made
    get api_v1_bookable_slots_path(location_id: @schedule.location_id), as: :json
  end

  def and_the_correct_slots_are_returned
    expect(@json.count).to eq(1)

    expect(@json.first).to eq(
      'date'  => '2017-05-31',
      'start' => BookableSlot::AM.start,
      'end'   => BookableSlot::AM.end
    )
  end

  def when_a_request_for_a_location_without_a_schedule_is_made
    get api_v1_bookable_slots_path(location_id: 'deadbeef'), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_slots_are_serialized_as_json
    @json = JSON.parse(response.body).tap do |json|
      expect(json.first.keys).to match_array(%w(date start end))
    end
  end
end