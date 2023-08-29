require 'rails_helper'

RSpec.describe BookingManagerAppointmentForm do
  subject do
    described_class.new(
      location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      booking_location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      name: 'Rick James',
      email: 'rick@example.com',
      phone: '0208 252 4777',
      date_of_birth: '01/01/1950',
      defined_contribution_pot_confirmed: true,
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
      scheduled: 'true',
      recording_consent: true,
      third_party: false,
      bsl_video: false,
      data_subject_consent_obtained: false,
      printed_consent_form_required: false,
      power_of_attorney: false,
      email_consent_form_required: false,
      data_subject_name: '',
      consent_address_line_one: '',
      consent_address_line_two: '',
      consent_address_line_three: '',
      consent_town: '',
      consent_county: '',
      consent_postcode: '',
      email_consent: ''
    )
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    context 'when third party booked' do
      before do
        subject.third_party = true
        subject.printed_consent_form_required = false
        subject.data_subject_name = 'Bob Bobson'
        subject.data_subject_date_of_birth = '1950-01-01'.to_date
      end

      it 'requires a data subject name' do
        subject.data_subject_name = nil

        expect(subject).to be_invalid
      end

      it 'requires a data subject date of birth' do
        subject.data_subject_date_of_birth = nil

        expect(subject).to be_invalid
      end

      context 'when a printed consent form is requested' do
        it 'requires an address' do
          subject.printed_consent_form_required = true

          expect(subject).to be_invalid

          subject.consent_address_line_one = '13 Some Street'
          subject.consent_town = 'Some Town'
          subject.consent_postcode = 'RM1 1AA'

          expect(subject).to be_valid

          subject.power_of_attorney = true

          expect(subject).to be_invalid
        end
      end

      context 'when an email consent form is requested' do
        it 'requires a consent email' do
          subject.email_consent_form_required = true
          subject.email_consent = ''
          expect(subject).to be_invalid

          subject.email_consent = 'ben@example.com'
          expect(subject).to be_valid
        end
      end

      context 'when power of attorney is specified' do
        it 'cannot also specify data subject consent' do
          subject.power_of_attorney = true
          subject.data_subject_consent_obtained = true

          expect(subject).to be_invalid

          subject.data_subject_consent_obtained = false

          expect(subject).to be_valid
        end

        it 'cannot also specify consent required' do
          subject.power_of_attorney = true
          subject.printed_consent_form_required = true

          expect(subject).to be_invalid

          subject.printed_consent_form_required = false
          subject.email_consent_form_required = true
          subject.email_consent = 'ben@example.com'

          expect(subject).to be_invalid
        end
      end

      context 'when data subject consent is obtained' do
        it 'cannot also specify power of attorney' do
          subject.power_of_attorney = true
          subject.data_subject_consent_obtained = true

          expect(subject).to be_invalid

          subject.power_of_attorney = false

          expect(subject).to be_valid
        end
      end
    end

    context 'when the appointment is on an adhoc basis' do
      before do
        subject.scheduled = false
        subject.first_choice_slot = ''
      end

      it 'requires the adhoc particulars' do
        expect(subject).to be_invalid

        subject.guider_id = 1
        subject.ad_hoc_start_at = '2019-12-25 13:00:00 UTC'

        expect(subject).to be_valid
      end

      it 'does not permit overlaps' do
        subject.guider_id = 1
        subject.ad_hoc_start_at = '2019-12-25 13:00:00 UTC'

        expect(subject).to be_valid

        create(:appointment, proceeded_at: '2019-12-25 13:00:00 UTC')

        expect(subject).to be_invalid
      end
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

      it 'is invalid if I am exactly 49 years old at my first_choice_slot' do
        subject.date_of_birth = '01/01/2000'
        subject.first_choice_slot = '2049-12-31-1300-1700'

        expect(subject).to_not be_valid
      end

      it 'is invalid if I am exactly 49 years old at one of my slots' do
        subject.date_of_birth = '01/01/2000'
        subject.first_choice_slot = '2049-12-31-1300-1700'

        expect(subject).to_not be_valid
      end

      context 'when no slots were selected' do
        it 'is not valid' do
          subject.first_choice_slot = ''

          expect(subject).to be_invalid
        end
      end
    end
  end

  describe 'create_appointment!' do
    it 'fails to create a booking if the age_range is incorrect' do
      subject.date_of_birth = '01/01/2000'
      subject.first_choice_slot = '2049-31-12-1300-1700'
      expect { subject.create_appointment! }.to raise_error(ArgumentError)
    end

    it 'creates a booking if the age range is 50-54' do
      subject.date_of_birth = '01/01/2000'
      subject.first_choice_slot = '2050-01-01-1300-1700'

      expect(subject.create_appointment!).to be_persisted
    end
  end
end
