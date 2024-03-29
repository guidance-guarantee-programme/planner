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
  let(:params) { {} }

  subject { described_class.new(booking_request, params) }

  describe 'validation' do
    let(:params) do
      {
        'guider_id' => 1,
        'location_id' => 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        'date' => '2016-06-21',
        'time(4i)' => '13',
        'time(5i)' => '00',
        'name' => 'Mick Smith',
        'email' => 'mick@example.com',
        'phone' => '01189 889 889',
        'memorable_word' => 'snoopy',
        'date_of_birth' => '1950-01-01',
        'accessibility_requirements' => '1',
        'defined_contribution_pot_confirmed' => 'true'
      }
    end

    before { travel_to '2016-06-20 13:00' }
    after  { travel_back }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    context 'with an address' do
      it 'does not require an email' do
        subject.email = ''

        expect(subject).to be_valid
      end
    end

    context 'with no address' do
      it 'requires an email address' do
        booking_request.address_line_one = ''
        subject.email = ''

        expect(subject).to_not be_valid
      end
    end

    it 'must not be associated with an existing appointment' do
      booking_request.appointment = build(:appointment)

      expect(subject).to_not be_valid
    end

    it 'requires a name' do
      params[:name] = ''

      expect(subject).to_not be_valid
    end

    it 'requires a phone' do
      params[:phone] = ''

      expect(subject).to_not be_valid
    end

    it 'requires a memorable word' do
      params[:memorable_word] = ''

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

    describe '#time' do
      it 'is required' do
        params['time(4i)'] = ''
        params['time(5i)'] = ''

        expect(subject).to be_invalid
      end

      it 'must be during permitted hours' do
        params['time(4i)'] = '00'

        expect(subject).to be_invalid
      end
    end

    describe '#date' do
      it 'is required' do
        params[:date] = ''

        expect(subject).to_not be_valid
      end

      it 'can fall on the same day' do
        params[:date] = '2016-06-20'

        expect(subject).to be_valid
      end

      it 'must be no sooner than the current date' do
        params[:date] = '2016-06-19'

        expect(subject).to_not be_valid
      end
    end
  end

  it 'delegates booking specifics to the booking request' do
    expect(subject.name).to eq(booking_request.name)
    expect(subject.email).to eq(booking_request.email)
    expect(subject.phone).to eq(booking_request.phone)
    expect(subject.date_of_birth).to eq(booking_request.date_of_birth)
    expect(subject.reference).to eq(booking_request.reference)
    expect(subject.memorable_word).to eq(booking_request.memorable_word)
    expect(subject.accessibility_requirements).to eq(booking_request.accessibility_requirements)
    expect(subject.additional_info).to eq(booking_request.additional_info)
    expect(subject.primary_slot).to eq(booking_request.primary_slot)
    expect(subject.secondary_slot).to eq(booking_request.secondary_slot)
    expect(subject.tertiary_slot).to eq(booking_request.tertiary_slot)
    expect(subject.agent).to eq(booking_request.agent)
  end

  describe '#time' do
    context 'when provided with params' do
      let(:params) { Hash['time(4i)' => '13', 'time(5i)' => '00'] }

      it 'normalises the params into the required time format' do
        expect(subject.time.strftime('%H:%M')).to eq('13:00')
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
