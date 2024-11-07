require 'rails_helper'

RSpec.describe LocationAwareEntity do
  context 'when decorating a BookingRequest' do
    let(:booking_location) do
      instance_double(
        BookingLocations::Location, name: 'Hackney', hidden?: false, online_booking_reply_to: 'parent@example.com'
      )
    end

    let(:booking_request) { instance_double(BookingRequest, location_id: 'deadbeef') }

    subject do
      described_class.new(booking_location: booking_location, entity: booking_request)
    end

    describe '#online_booking_reply_to' do
      context 'when the actual location has specified a reply-to' do
        it 'returns the actual location reply-to' do
          allow(booking_location).to receive(:location_for).and_return(
            double(online_booking_reply_to: 'abc@example.com')
          )

          expect(subject.online_booking_reply_to).to eq('abc@example.com')
        end
      end

      context 'when the actual location does not specify a reply-to' do
        it 'returns the booking location reply-to' do
          allow(booking_location).to receive(:location_for).and_return(double(online_booking_reply_to: ''))

          expect(subject.online_booking_reply_to).to eq('parent@example.com')
        end
      end
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
    let(:actual_location) { instance_double(BookingLocations::Location, accessibility_information: 'Broken lift') }
    let(:appointment) { instance_double(Appointment, location_id: 'deadbeef', guider_id: 1) }

    subject do
      described_class.new(booking_location: booking_location, entity: appointment)
    end

    it 'returns access information' do
      allow(booking_location).to receive(:location_for).and_return(actual_location)

      expect(subject.accessibility_information).to eq('Broken lift')
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
