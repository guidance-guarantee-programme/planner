require 'rails_helper'

RSpec.describe LocationAwareBookingRequest do
  let(:booking_location) { instance_double(BookingLocations::Location) }
  let(:booking_request) { instance_double(BookingRequest, location_id: 'deadbeef') }

  subject do
    described_class.new(booking_location: booking_location, booking_request: booking_request)
  end

  describe '#location_name' do
    it 'delegates `location_name` to the booking location' do
      expect(booking_location).to receive(:name_for)
        .with(booking_request.location_id)
        .and_return('Hackney')

      expect(subject.location_name).to eq('Hackney')
    end
  end
end
