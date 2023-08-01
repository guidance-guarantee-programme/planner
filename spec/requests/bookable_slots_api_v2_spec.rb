require 'rails_helper'

RSpec.describe 'GET /api/v2/locations/{location_id}/bookable_slots' do
  scenario 'Returns real availability for locations with schedules' do
    travel_to '2017-05-26 13:00' do
      given_a_location_with_a_schedule_exists
      when_a_request_for_the_location_is_made
      then_the_service_responds_ok
      and_slots_are_serialized_as_json
      and_the_correct_slots_are_returned
    end
  end

  scenario 'Returns empty availability for locations without schedules' do
    when_a_request_for_a_location_without_a_schedule_is_made
    then_the_service_responds_ok
    and_an_empty_array_is_serialized_as_json
  end

  def given_a_location_with_a_schedule_exists
    @schedule = create(:schedule).tap do |schedule|
      # the following realtime slots are deduplicated
      create(:bookable_slot, schedule: schedule, start_at: '2017-06-05 09:00', guider_id: 2)
      create(:bookable_slot, schedule: schedule, start_at: '2017-06-05 09:00')
      # excluded as it's for a pending appointment
      create_appointment_with_booking_slot(
        schedule: schedule,
        start_at: '2017-06-06 09:00',
        guider_id: 3
      )
      # included as the underlying appointment is cancelled
      create_appointment_with_booking_slot(
        schedule: schedule,
        start_at: '2017-06-06 09:00',
        guider_id: 4,
        status: :cancelled_by_customer,
        secondary_status: '15'
      )
      # excluded since an appointment overlaps the start/end
      @overlapping = create(
        :bookable_slot,
        schedule: schedule,
        start_at: '2017-06-06 13:30',
        end_at: '2017-06-06 14:30'
      )
      create(:appointment, proceeded_at: @overlapping.start_at.advance(minutes: 30))
    end
  end

  def when_a_request_for_the_location_is_made
    get api_v2_bookable_slots_path(location_id: @schedule.location_id), as: :json
  end

  def and_the_correct_slots_are_returned
    expect(@json.count).to eq(2)

    expect(@json).to eq(
      '2017-06-05' => ['2017-06-05T09:00:00.000Z'],
      '2017-06-06' => ['2017-06-06T09:00:00.000Z']
    )
  end

  def when_a_request_for_a_location_without_a_schedule_is_made
    get api_v2_bookable_slots_path(location_id: 'deadbeef'), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_slots_are_serialized_as_json
    @json = JSON.parse(response.body)
  end

  def and_an_empty_array_is_serialized_as_json
    expect(JSON.parse(response.body)).to eq({})
  end

  def create_appointment_with_booking_slot(schedule:, start_at:, guider_id:, status: :pending, secondary_status: '')
    slot    = create(:bookable_slot, schedule: schedule, start_at: start_at, guider_id: guider_id)
    booking = build(:hackney_booking_request, number_of_slots: 0)
    booking.slots.build(date: start_at.to_date, from: '0900', to: '1000', priority: 1)

    create(
      :appointment,
      booking_request: booking,
      guider_id: guider_id,
      proceeded_at: slot.start_at,
      status: status,
      secondary_status: secondary_status
    )
  end
end
