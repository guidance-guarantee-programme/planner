require 'rails_helper'

RSpec.describe 'POST /api/v1/booking_requests' do
  scenario 'create a valid booking request' do
    given_the_client_identifies_as_pension_wise
    when_a_valid_booking_request_is_made
    then_the_booking_request_is_created
    and_the_booking_has_associated_slots
    and_the_service_responds_with_a_201
    and_the_customer_receives_a_confirmation_email
  end

  def given_the_client_identifies_as_pension_wise
    create(:pension_wise_api_user)
  end

  def when_a_valid_booking_request_is_made
    valid_payload = {
      'booking_request' => {
        'location_id' => 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        'name' => 'Morty Sanchez',
        'email' => 'morty@example.com',
        'phone' => '0208 252 4729',
        'memorable_word' => 'science',
        'age_range' => '50-54',
        'accessibility_requirements' => false,
        'marketing_opt_in' => true,
        'defined_contribution_pot' => true,
        'slots' => [
          {
            'date' => '2016-01-01',
            'from' => '0900',
            'to' => '1300',
            'priority' => 1
          },
          {
            'date' => '2016-01-02',
            'from' => '1300',
            'to' => '1700',
            'priority' => 2
          },
          {
            'date' => '2016-01-02',
            'from' => '0900',
            'to' => '1300',
            'priority' => 3
          }
        ]
      }
    }

    post api_v1_booking_requests_path(format: :json), valid_payload.as_json
  end

  def then_the_booking_request_is_created
    @booking = BookingRequest.last

    expect(@booking).to have_attributes(
      location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      name: 'Morty Sanchez',
      email: 'morty@example.com',
      phone: '0208 252 4729',
      memorable_word: 'science',
      age_range: '50-54',
      accessibility_requirements: false,
      marketing_opt_in: true,
      defined_contribution_pot: true
    )
  end

  def and_the_booking_has_associated_slots
    expect(@booking.slots.size).to eq(3)

    expect(@booking.slots.first).to have_attributes(
      date: Date.parse('2016-01-01'),
      from: '0900',
      to: '1300',
      priority: 1
    )
  end

  def and_the_service_responds_with_a_201
    expect(response).to be_created
  end

  def and_the_customer_receives_a_confirmation_email
    skip
  end
end
