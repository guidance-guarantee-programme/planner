require 'rails_helper'

RSpec.describe LocationAwareEntity do
  context 'when decorating a BookingRequest' do
    let(:booking_location) do
      instance_double(BookingLocations::Location, name: 'Hackney', hidden?: false)
    end

    let(:booking_request) { instance_double(BookingRequest, location_id: 'deadbeef') }

    subject do
      described_class.new(booking_location: booking_location, entity: booking_request)
    end

    describe '#entity' do
      it 'unwraps the delegated instance' do
        expect(subject.entity).to eq(booking_request)
      end
    end

    describe '#location_name' do
      it 'delegates to the entity' do
        expect(booking_location).to receive(:location_for)
          .with(booking_request.location_id)
          .and_return(booking_location)

        expect(subject.location_name).to eq('Hackney')
      end
    end

    describe '#guider_name' do
      it 'is empty' do
        expect(subject.guider_name).to be_empty
      end
    end
  end

  context 'when decorating an Appointment' do
    let(:booking_location) { instance_double(BookingLocations::Location) }
    let(:appointment) { instance_double(Appointment, location_id: 'deadbeef', guider_id: 1) }

    subject do
      described_class.new(booking_location: booking_location, entity: appointment)
    end

    describe '#guider_name' do
      it 'delegates `guider_name` to the entity' do
        expect(booking_location).to receive(:guider_name_for)
          .with(appointment.guider_id)
          .and_return('Ben Lovell')

        expect(subject.guider_name).to eq('Ben Lovell')
      end
    end

    describe '#address_lines' do
      before do
        allow(booking_location).to receive(:location_for)
          .with(appointment.location_id)
          .and_return(
            instance_double(BookingLocations::Location, address: '1 Some Street, Some Place, Some Town')
          )
      end

      it 'returns an array of address lines for the given location ID' do
        expect(subject.address_lines.count).to eq(3)
        expect(subject.address_lines.first).to eq('1 Some Street')
        expect(subject.address_lines.last).to eq('Some Town')
      end
    end
  end
end
