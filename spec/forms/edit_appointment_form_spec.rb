require 'rails_helper'

RSpec.describe EditAppointmentForm do
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }
  let(:underlying_appointment) { build_stubbed(:appointment) }
  let(:appointment) do
    LocationAwareEntity.new(
      entity: underlying_appointment,
      booking_location: hackney
    )
  end
  let(:params) { Hash.new }

  subject { described_class.new(appointment, params) }

  described_class::ATTRIBUTES.each do |attribute|
    it "delegates #{attribute} to the appointment" do
      expect(subject.public_send(attribute)).to eq(appointment.public_send(attribute))
    end
  end

  describe 'binding fields when params are passed' do
    let(:params) do
      {
        name: 'name',
        email: 'email',
        phone: 'phone',
        location_id: 'location_id',
        guider_id: 'guider_id'
      }
    end

    described_class::EDITABLE_ATTRIBUTES.each do |attribute|
      it "correctly binds #{attribute}" do
        expect(subject.public_send(attribute)).to eq(params[attribute])
      end
    end
  end

  it 'delegates slots to the underlying booking request' do
    expect(subject.primary_slot).to eq(appointment.booking_request.primary_slot)
    expect(subject.secondary_slot).to eq(appointment.booking_request.secondary_slot)
    expect(subject.tertiary_slot).to eq(appointment.booking_request.tertiary_slot)
  end

  describe '#guiders' do
    it 'returns the guiders from the booking location' do
      expect(subject.guiders).to eq(hackney.guiders)
    end
  end

  describe '#flattened_locations' do
    it 'flattens locations with a mapper' do
      expect(FlattenedLocationMapper).to receive(:map).with(hackney)

      subject.flattened_locations
    end
  end

  describe '#proceeded_at' do
    context 'when the time params are provided' do
      let(:params) do
        {
          'proceeded_at'     => '2016-06-20',
          'proceeded_at(4i)' => '13',
          'proceeded_at(5i)' => '15'
        }
      end

      it 'is parsed correctly' do
        expect(subject.proceeded_at).to eq('2016-06-20 13:15')
      end
    end
  end

  describe '#update' do
    let(:params) do
      {
        'name'             => 'Ben Lovell',
        'email'            => 'ben@example.com',
        'phone'            => '07715 930 444',
        'guider_id'        => '2',
        'location_id'      => 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        'proceeded_at'     => '2016-06-20',
        'proceeded_at(4i)' => '13',
        'proceeded_at(5i)' => '15'
      }
    end

    it 'updates the underlying appointment' do
      expect(underlying_appointment).to receive(:update).with(
        name: 'Ben Lovell',
        email: 'ben@example.com',
        phone: '07715 930 444',
        guider_id: '2',
        location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        proceeded_at: Time.zone.parse('2016-06-20 13:15')
      )

      subject.update
    end
  end
end
