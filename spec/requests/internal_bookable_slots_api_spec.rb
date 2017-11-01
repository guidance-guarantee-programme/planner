require 'rails_helper'

RSpec.describe 'GET /locations/:location_id/bookable_slots.json' do
  scenario 'Retrieving slots in a given location' do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2017-05-01 13:00' do
        given_a_location_with_a_schedule_exists
        when_a_request_for_bookable_slots_is_made
        then_the_service_responds_ok
        and_the_slots_are_serialized_as_json
      end
    end
  end

  def given_a_location_with_a_schedule_exists
    @schedule = create(:schedule, :blank, monday_am: true, &:generate_bookable_slots!)
  end

  def when_a_request_for_bookable_slots_is_made
    get bookable_slots_path(location_id: @schedule.location_id),
        params: { start: '2017-05-01', end: '2017-05-31' },
        as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_slots_are_serialized_as_json
    @json = JSON.parse(response.body)

    # 3 slots returned for the given month
    expect(@json.count).to eq(4)
    expect(@json.first).to include(
      'start' => '2017-05-08T09:00:00.000Z',
      'end'   => '2017-05-08T13:00:00.000Z'
    )
  end
end
