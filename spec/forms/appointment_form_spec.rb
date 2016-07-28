require 'rails_helper'

RSpec.describe AppointmentForm do
  let(:hackney) do
    BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end
  let(:booking_request) do
    LocationAwareEntity.new(
      entity: create(:hackney_booking_request),
      booking_location: hackney
    )
  end
  let(:params) { Hash.new }

  subject { described_class.new(booking_request, params) }

  describe 'validation' do
    let(:params) do
      {
        'guider_id'   => 1,
        'location_id' => 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        'date'        => '2016-06-21',
        'time(4i)'    => '13',
        'time(5i)'    => '00'
      }
    end

    before { travel_to '2016-06-20' }
    after  { travel_back }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'must not be associated with an existing appointment' do
      booking_request.appointment = build(:appointment)

      expect(subject).to_not be_valid
    end

    it 'requires a location ID' do
      params[:location_id] = ''

      expect(subject).to_not be_valid
    end

    it 'requires a guider ID' do
      params[:guider_id] = ''

      expect(subject).to_not be_valid
    end

    describe '#date' do
      it 'is required' do
        params[:date] = ''

        expect(subject).to_not be_valid
      end

      it 'must be past the current date' do
        %w(2016-06-19 2016-06-20).each do |date|
          params[:date] = date

          expect(subject).to_not be_valid
        end
      end
    end
  end

  it 'delegates booking specifics to the booking request' do
    expect(subject.name).to eq(booking_request.name)
    expect(subject.email).to eq(booking_request.email)
    expect(subject.phone).to eq(booking_request.phone)
    expect(subject.age_range).to eq(booking_request.age_range)
    expect(subject.reference).to eq(booking_request.reference)
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

  describe '#flattened_locations' do
    it 'flattens locations with a mapper' do
      expect(FlattenedLocationMapper).to receive(:map).with(hackney)

      subject.flattened_locations
    end
  end

  describe '#date' do
    it 'defaults to the primary slot date' do
      expect(subject.date).to eq(booking_request.primary_slot.date)
    end
  end

  describe '#time' do
    context 'when provided with params' do
      let(:params) { Hash['time(4i)' => '13', 'time(5i)' => '00'] }

      it 'normalises the params into the required time format' do
        expect(subject.time.strftime('%H:%M')).to eq('13:00')
      end
    end

    context 'when no params are provided' do
      it 'defaults to the primary slot start time' do
        expect(subject.time.strftime('%H:%M')).to eq(booking_request.primary_slot.delimited_from)
      end
    end
  end

  describe '#location_id' do
    context 'when the `location_id` param is present' do
      let(:params) { Hash[location_id: 'deadbeef-e3cf-45cd-a8ff-9ba827b8e7ef'] }

      it 'returns that' do
        expect(subject.location_id).to eq(params[:location_id])
      end
    end

    context 'when no `location_id` is present' do
      it 'returns the customer-selected `location_id`' do
        expect(subject.location_id).to eq('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
      end
    end
  end

  describe '#appointment_params' do
    it 'returns a hash of params to create an `Appointment` with a mapper' do
      expect(AppointmentMapper).to receive(:map).with(subject)

      subject.appointment_params
    end
  end
end
