require 'rails_helper'

RSpec.describe AgentBookingForm do
  subject do
    described_class.new(
      location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      booking_location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      name: 'Rick James',
      email: 'rick@example.com',
      phone: '0208 252 4777',
      date_of_birth: '01/01/1950',
      memorable_word: 'couch',
      first_choice_slot: '2017-01-01-1300-1700',
      address_line_one: '1 Main Street',
      address_line_two: '',
      address_line_three: '',
      town: 'London',
      county: 'London',
      postcode: 'W1 1AA',
      where_you_heard: 1,
      gdpr_consent: 'yes',
      accessibility_requirements: false,
      additional_info: '',
      recording_consent: true,
      nudged: true,
      third_party: false
    )
  end

  it 'is scheduled' do
    expect(subject).to be_scheduled
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'requires GDPR consent to be specified' do
      subject.gdpr_consent = ''
      expect(subject).to be_invalid
    end

    context 'when accessibility requirements were specified' do
      it 'requires additional info' do
        subject.accessibility_requirements = true
        expect(subject).to be_invalid

        subject.additional_info = 'Needs wheelchair access'
        expect(subject).to be_valid
      end
    end

    context 'dob validation bug' do
      it 'requires a date of birth' do
        subject.date_of_birth = ''

        expect(subject).to be_invalid
      end

      it 'requires a four digit year fragment' do
        subject.date_of_birth = '01/02/53'

        expect(subject).to be_invalid
      end

      it 'requires a correctly formatted date' do
        subject.date_of_birth = '01/19/1949'

        expect(subject).to be_invalid
      end
    end

    context 'when one of the legacy journey email addresses are provided' do
      %w(tpbooking@pensionwise.gov.uk tpbookings@pensionwise.gov.uk).each do |email|
        it "requires an address for '#{email}'" do
          subject.email = email
          subject.address_line_one = ''

          expect(subject).to be_invalid
        end
      end
    end

    context 'when an email is not provided' do
      it 'requires an address' do
        subject.email = ''
        subject.address_line_one = ''

        expect(subject).to be_invalid
      end

      it 'is valid when an address is supplied instead' do
        subject.email = ''

        expect(subject).to be_valid
      end
    end

    context 'eligibility' do
      it 'is valid if I am exactly 50 years old at my first_choice_slot' do
        subject.date_of_birth = '01/01/2000'
        subject.first_choice_slot = '2050-01-01-1300-1700'

        expect(subject).to be_valid
      end

      it 'is valid if I am exactly 49 years old at my first_choice_slot' do
        subject.date_of_birth = '01/01/2000'
        subject.first_choice_slot = '2049-12-31-1300-1700'

        expect(subject).to be_valid
      end

      it 'is valid if I am exactly 49 years old at one of my slots' do
        subject.date_of_birth = '01/01/2000'
        subject.first_choice_slot = '2049-12-31-1300-1700'

        expect(subject).to be_valid
      end

      context 'when no slots were selected' do
        it 'is not valid' do
          subject.first_choice_slot = ''

          expect(subject).to be_invalid
        end
      end
    end
  end

  describe 'create_booking!' do
    it 'fails to create a booking if the age_range is incorrect' do
      subject.date_of_birth = '01/01/2000'
      subject.first_choice_slot = '2049-31-12-1300-1700'
      expect { subject.create_booking! }.to raise_error(ArgumentError)
    end

    it 'creates a booking if the age range is 50-54' do
      subject.date_of_birth = '01/01/2000'
      subject.first_choice_slot = '2050-01-01-1300-1700'

      expect(subject.create_booking!).to be_persisted
    end
  end
end
