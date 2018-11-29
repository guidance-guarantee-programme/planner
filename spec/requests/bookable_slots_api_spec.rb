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

  def given_a_location_with_a_schedule_exists # rubocop:disable AbcSize
    @schedule = create(:schedule).tap do |schedule|
      # excluded due to falling within the grace period
      create(:bookable_slot, :am, schedule: schedule)
      # will be returned
      create(:bookable_slot, :am, schedule: schedule, date: GracePeriod.start)
      # the following realtime slots are deduplicated
      create(:bookable_slot, :realtime, schedule: schedule, date: 10.days.from_now, guider_id: 2)
      create(:bookable_slot, :realtime, schedule: schedule, date: 10.days.from_now)
      # excluded as it's for a pending appointment
      create_appointment_with_booking_slot(
        schedule: schedule,
        date: 11.days.from_now,
        guider_id: 3
      )
      # included as the underlying appointment is cancelled
      create_appointment_with_booking_slot(
        schedule: schedule,
        date: 11.days.from_now,
        guider_id: 4,
        status: :cancelled_by_customer
      )
    end
  end

  def when_a_request_for_the_location_is_made
    get api_v1_bookable_slots_path(location_id: @schedule.location_id), as: :json
  end

  def and_the_correct_slots_are_returned
    expect(@json.count).to eq(3)

    expect(@json).to eq(
      [
        {
          'date'  => '2017-05-31',
          'start' => BookableSlot::AM.start,
          'end'   => BookableSlot::AM.end
        },
        {
          'date'  => '2017-06-05',
          'start' => '0900',
          'end'   => '1000'
        },
        {
          'date'  => '2017-06-06',
          'start' => '0900',
          'end'   => '1000'
        }
      ]
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

  def create_appointment_with_booking_slot(schedule:, date:, guider_id:, status: :pending)
    slot    = create(:bookable_slot, :realtime, schedule: schedule, date: date, guider_id: guider_id)
    booking = build(:hackney_booking_request, number_of_slots: 0)
    booking.slots.build(date: date, from: '0900', to: '1000', priority: 1)

    create(
      :appointment,
      booking_request: booking,
      guider_id: guider_id,
      proceeded_at: slot.start_at,
      status: status
    )
  end
end
