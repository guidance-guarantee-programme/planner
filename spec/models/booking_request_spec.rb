require 'rails_helper'

RSpec.describe BookingRequest do
  describe 'purging conditional third party data' do
    context 'when subsequently unchecking `printed_consent_form_required`' do
      subject { build_stubbed(:third_party_consent_form_booking_request) }

      it 'removes the related conditional data' do
        subject.printed_consent_form_required = false

        subject.validate

        expect(subject).to have_attributes(
          consent_address_line_one: '',
          consent_address_line_two: '',
          consent_address_line_three: '',
          consent_town: '',
          consent_county: '',
          consent_postcode: ''
        )
      end

      it 'is triggered by third party change too' do
        subject.third_party = false

        subject.validate

        expect(subject).to have_attributes(
          consent_address_line_one: '',
          consent_address_line_two: '',
          consent_address_line_three: '',
          consent_town: '',
          consent_county: '',
          consent_postcode: ''
        )
      end
    end

    context 'when subsequently unchecking `email_consent_form_required`' do
      subject { build_stubbed(:third_party_email_consent_form_booking_request) }

      it 'removes the related conditional data' do
        subject.email_consent_form_required = false

        subject.validate

        expect(subject.email_consent).to eq('')
      end

      it 'is triggered by third party change too' do
        subject.third_party = false

        subject.validate

        expect(subject.email_consent).to eq('')
      end
    end

    context 'when subsequently unchecking `power_of_attorney`' do
      subject { create(:third_party_power_of_attorney_booking_request) }

      it 'removes the related attachment' do
        subject.power_of_attorney = false

        subject.validate

        expect(subject.power_of_attorney_evidence).not_to be_attached
      end

      it 'is triggered by third party change too' do
        subject.third_party = false

        subject.validate

        expect(subject.power_of_attorney_evidence).not_to be_attached
      end
    end

    context 'when subsequently unchecking `data_subject_consent_obtained`' do
      subject { create(:third_party_data_subject_consent_booking_request) }

      it 'removes the related attachment' do
        subject.data_subject_consent_obtained = false

        subject.validate

        expect(subject.data_subject_consent_evidence).not_to be_attached
      end

      it 'is triggered by third party change too' do
        subject.third_party = false

        subject.validate

        expect(subject.data_subject_consent_evidence).not_to be_attached
      end
    end
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(build(:booking_request)).to be_valid
    end

    it 'validates maximum length of `additional_info`' do
      expect(build(:booking_request, additional_info: '*' * 321)).to_not be_valid
    end

    it 'requires a booking_location_id' do
      expect(build(:booking_request, booking_location_id: '')).to_not be_valid
    end

    it 'requires a location_id' do
      expect(build(:booking_request, location_id: '')).to_not be_valid
    end

    it 'requires a name' do
      expect(build(:booking_request, name: '')).to_not be_valid
    end

    describe '#email' do
      it 'is required' do
        expect(build(:booking_request, email: '')).to_not be_valid
      end

      it 'validates against autocomplete madness' do
        expect(build(:booking_request, email: 'arthur@hotmail.co.uk01636677350')).to_not be_valid
      end
    end

    it 'requires a phone' do
      expect(build(:booking_request, phone: '')).to_not be_valid
    end

    it 'requires a memorable word' do
      expect(build(:booking_request, memorable_word: '')).to_not be_valid
    end

    it 'requires a permitted age range' do
      booking_request = build(:booking_request, age_range: '')
      expect(booking_request).to_not be_valid

      booking_request.age_range = 'whoops'
      expect(booking_request).to_not be_valid
    end

    it 'requires accessibility_requirements' do
      expect(build(:booking_request, accessibility_requirements: '')).to_not be_valid
    end

    it 'requires defined_contribution_pot_confirmed' do
      expect(build(:booking_request, defined_contribution_pot_confirmed: '')).to_not be_valid
    end

    it 'requires at least one slot' do
      build(:booking_request) do |booking|
        booking.slots.clear

        expect(booking).to_not be_valid
      end
    end

    context 'when created before the default third-party validation cut-off' do
      it 'does not enforce the third party attributes' do
        @booking = create(:third_party_data_subject_consent_booking_request, created_at: 3.weeks.ago)

        @booking.data_subject_name = ''
        @booking.data_subject_date_of_birth = nil

        expect(@booking).to be_valid
      end
    end

    describe 'allocation of slots' do
      before { travel_to('2018-11-05 13:00') }
      after { travel_back }

      context 'when a realtime slot is chosen' do
        before do
          @available_slot  = create(:bookable_slot, start_at: '2018-11-09 09:00')
          @booking_request = build(:hackney_booking_request, number_of_slots: 0)
          @booking_request.slots.build(date: '2018-11-09', from: '0900', to: '1000', priority: 1)
        end

        context 'when an available slot can be allocated' do
          it 'is valid' do
            expect(@booking_request).to be_valid
          end
        end

        context 'when no available slot can be allocated' do
          it 'is not valid' do
            skip 'This needs revisiting'

            # has an associated appointment
            @appointment = create(
              :appointment,
              guider_id: @available_slot.guider_id,
              proceeded_at: @available_slot.start_at,
              booking_request: @booking_request
            )

            expect(@booking_request).to be_invalid
          end
        end
      end

      context 'when non-realtime slots are chosen' do
        it 'is valid' do
          @booking_request = build(:booking_request)
          expect(@booking_request).not_to be_realtime
          expect(@booking_request).to be_valid
        end
      end
    end
  end

  describe '#reference' do
    it 'returns the #id as a string' do
      booking = BookingRequest.new(id: 1)

      expect(booking.id.to_s).to eq(booking.reference)
    end
  end

  describe '#slots' do
    let(:request) { create(:booking_request, number_of_slots: 3) }

    it 'is returned in order of #priority' do
      expect(request.slots.pluck(:priority)).to eq([1, 2, 3])
    end

    it 'cascades deletes to the associated slots' do
      expect { request.destroy }.to change { request.slots.count }.by(-3)
    end
  end

  describe '#name' do
    it 'titleizes the name' do
      expect(build(:booking_request, name: 'ben lovell').name).to eq('Ben Lovell')
    end
  end

  it 'defaults `active`' do
    expect(described_class.new).to be_active
  end

  it 'defaults `placed_by_agent`' do
    expect(described_class.new).to_not be_placed_by_agent
  end

  it 'defaults `where_you_heard`' do
    expect(described_class.new.where_you_heard).to be_zero
  end

  describe '#memorable_word' do
    it 'can be obscured' do
      expect(build_stubbed(:booking_request).memorable_word).to eq('spaceship')
      expect(build_stubbed(:booking_request).memorable_word(obscure: true)).to eq('s*******p')
      expect(build_stubbed(:booking_request, memorable_word: nil).memorable_word(obscure: true)).to eq('')
    end
  end

  describe '#realtime?' do
    context 'when the first slot is realtime' do
      it 'is true' do
        build(:booking_request).tap do |booking_request|
          expect(booking_request).not_to be_realtime

          booking_request.primary_slot.from = '0900'
          booking_request.primary_slot.to   = '1000'

          expect(booking_request).to be_realtime
        end
      end
    end
  end
end
