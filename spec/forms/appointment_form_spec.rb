require 'rails_helper'

RSpec.describe AppointmentForm do
  let(:hackney) do
    BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end
  let(:booking_request) do
    LocationAwareBookingRequest.new(
      booking_request: build_stubbed(:booking_request),
      booking_location: hackney
    )
  end
  let(:params) { Hash.new }

  subject { described_class.new(booking_request, params) }

  it 'delegates booking specifics to the booking request' do
    expect(subject.name).to eq(booking_request.name)
    expect(subject.email).to eq(booking_request.email)
    expect(subject.phone).to eq(booking_request.phone)
    expect(subject.age_range).to eq(booking_request.age_range)
    expect(subject.reference).to eq(booking_request.reference)
    expect(subject.location_id).to eq(booking_request.location_id)
    expect(subject.memorable_word).to eq(booking_request.memorable_word)
    expect(subject.accessibility_requirements).to eq(booking_request.accessibility_requirements)

    expect(subject.primary_slot).to eq(booking_request.primary_slot)
    expect(subject.secondary_slot).to eq(booking_request.secondary_slot)
    expect(subject.tertiary_slot).to eq(booking_request.tertiary_slot)
  end

  describe '#guiders' do
    it 'returns the guiders from the booking location' do
      expect(subject.guiders).to eq(hackney.guiders)
    end
  end
end
