require 'rails_helper'

RSpec.describe 'POST /api/v1/booking_requests' do
  scenario 'creating a valid appointment from a realtime slot' do
    travel_to '2018-11-05 13:00' do
      perform_enqueued_jobs do
        given_the_client_identifies_as_pension_wise
        and_the_hackney_booking_manager_exists
        and_a_schedule_with_realtime_slots_exists
        when_a_valid_booking_request_is_made
        then_the_service_responds_with_a_201
        and_the_appointment_details_are_serialized
        and_the_booking_request_is_created
        and_the_appointment_is_created
        and_the_customer_receives_a_confirmation_email
      end
    end
  end

  scenario 'the realtime slot disappears due to a race or otherwise' do
    given_the_client_identifies_as_pension_wise
    and_the_hackney_booking_manager_exists
    and_an_empty_schedule_exists
    when_a_valid_booking_request_is_made
    then_the_service_responds_with_a_422
    and_no_booking_is_created
  end

  def and_an_empty_schedule_exists
    @schedule = create(:schedule, :blank)
  end

  def then_the_service_responds_with_a_422
    expect(response).to be_unprocessable
  end

  def and_no_booking_is_created
    expect(BookingRequest.count).to be_zero
  end

  def given_the_client_identifies_as_pension_wise
    create(:pension_wise_api_user)
  end

  def and_the_hackney_booking_manager_exists
    create(:hackney_booking_manager)
  end

  def and_a_schedule_with_realtime_slots_exists
    @schedule = create(:schedule, :blank)
    @slot     = create(:bookable_slot, :realtime, date: '2018-11-08', schedule: @schedule)
  end

  def when_a_valid_booking_request_is_made
    valid_payload = {
      'booking_request' => {
        'booking_location_id' => 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        'location_id' => 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        'name' => 'Morty Sanchez',
        'email' => 'morty@example.com',
        'phone' => '0208 252 4729',
        'memorable_word' => 'science',
        'age_range' => '50-54',
        'date_of_birth' => '1950-01-01',
        'additional_info' => 'Additional Info',
        'accessibility_requirements' => false,
        'defined_contribution_pot_confirmed' => true,
        'placed_by_agent' => true,
        'where_you_heard' => 1,
        'gdpr_consent' => 'yes',
        'slots' => [
          {
            'date' => '2018-11-08',
            'from' => '0900',
            'to' => '1000',
            'priority' => 1
          }
        ]
      }
    }

    post api_v1_booking_requests_path, params: valid_payload, as: :json
  end

  def then_the_service_responds_with_a_201
    expect(response).to be_created
  end

  def and_the_appointment_details_are_serialized
    expect(JSON.parse(response.body)).to eq(
      'reference'    => Appointment.last.reference,
      'proceeded_at' => '2018-11-08T09:00:00.000Z',
      'location'     => 'Hackney'
    )
  end

  def and_the_booking_request_is_created
    @booking_request = BookingRequest.last

    expect(@booking_request).to have_attributes(
      booking_location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'
    )
  end

  def and_the_appointment_is_created
    expect(@booking_request.appointment).to have_attributes(
      name: 'Morty Sanchez',
      email: 'morty@example.com',
      phone: '0208 252 4729',
      guider_id: 1,
      location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      proceeded_at:  Time.zone.parse('2018-11-08 09:00'),
      status: 'pending',
      memorable_word: 'science',
      date_of_birth: 'Sun, 01 Jan 1950'.to_date,
      defined_contribution_pot_confirmed: true,
      accessibility_requirements: false,
      additional_info: 'Additional Info'
    )
  end

  def and_the_customer_receives_a_confirmation_email
    expect(ActionMailer::Base.deliveries.first.subject).to eq('Your Pension Wise Appointment')
  end
end
