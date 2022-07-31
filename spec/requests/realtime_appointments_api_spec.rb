require 'rails_helper'

RSpec.describe 'GET /locations/{location_id}/realtime_appointments' do
  scenario 'Returns a list of realtime appointments in the given timeframe' do
    travel_to '2018-11-01 13:00' do
      given_the_user_identifies_as_hackneys_booking_manager do
        given_a_schedule_with_realtime_slots_exists
        and_an_overlapping_realtime_appointment_exists
        when_a_request_for_realtime_appointments_is_made
        then_the_service_responds_ok
        and_the_appointments_are_serialized_as_json
      end
    end
  end

  def given_a_schedule_with_realtime_slots_exists
    @slot = create(:bookable_slot, start_at: '2018-11-07 09:00')
  end

  def and_an_overlapping_realtime_appointment_exists
    @booking = build(:hackney_booking_request, number_of_slots: 0)
    @booking.slots.build(date: '2018-11-07', from: '0900', to: '1000', priority: 1)

    @appointment = create(:appointment, booking_request: @booking, proceeded_at: @slot.start_at)
  end

  def when_a_request_for_realtime_appointments_is_made
    hackney_location_id = 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'

    get realtime_appointments_path(location_id: hackney_location_id),
        as: :json,
        params: { start: '2018-11-07 00:00', end: '2018-11-07 23:59' }
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_appointments_are_serialized_as_json
    JSON.parse(response.body).tap do |json|
      expect(json).to eq(
        [
          {
            'id'         => @appointment.id,
            'title'      => 'Mortimer Smith',
            'resourceId' => 1,
            'start'      => '2018-11-07T09:00:00.000Z',
            'end'        => '2018-11-07T10:00:00.000Z',
            'cancelled'  => false,
            'url'        => "/appointments/#{@appointment.id}/edit",
            'location'   => 'Hackney'
          }
        ]
      )
    end
  end
end
