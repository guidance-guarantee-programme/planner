require 'rails_helper'

RSpec.describe Appointment do
  subject { build_stubbed(:appointment, current_user: build_stubbed(:agent)) }

  context 'removing the third party flag' do
    it 'also removes third party from the booking' do
      appointment = build_stubbed(:appointment, :third_party_booking)

      appointment.third_party = false

      appointment.validate

      expect(appointment.booking_request).not_to be_third_party
    end
  end

  describe '#duplicates' do
    it 'matches the current booking location' do
      appointment = create(:appointment)

      # doesn't match the booking location
      create(:appointment, :taunton_booking_location)
      expect(appointment).not_to be_duplicates

      # matches the booking location
      inside = create(:appointment, guider_id: 3)
      expect(inside).to be_duplicates
    end

    it 'matches name' do
      appointment = create(:appointment, :with_agent, name: 'Ben L', email: '', phone: '0121 444 555')
      create(:appointment, name: 'Ben L', email: 'ben@ben.com', phone: '0131 333 444', guider_id: 2)

      expect(appointment).to be_duplicates
    end

    it 'matches pending statuses' do
      appointment = create(:appointment, :with_agent, name: 'Ben L', phone: '0131 333 444')
      create(:appointment, :with_agent, name: 'Ben L', phone: '0131 333 444', guider_id: 2, status: :completed)

      expect(appointment).to_not be_duplicates
    end
  end

  describe '.needing_reminder' do
    context 'with an appointment 7 days in the future' do
      it 'is included correctly based on its status' do
        appointment = create(:appointment, proceeded_at: 7.days.from_now, created_at: 1.day.ago, phone: '02082524727')

        expect(described_class.needing_reminder).to include(appointment)

        appointment.update(status: :cancelled_by_customer_sms)

        expect(described_class.needing_reminder).to be_empty
      end

      it 'excludes appointments created the same day' do
        appointment = create(:appointment, proceeded_at: 7.days.from_now)

        expect(described_class.needing_reminder).to_not include(appointment)
      end
    end
  end

  context 'when the status changes before saving' do
    it 'stores the associated statuses' do
      appointment = create(:appointment)

      expect(appointment.status_transitions.pluck(:status)).to match_array('pending')

      appointment.update(status: :cancelled_by_pension_wise)

      expect(appointment.status_transitions.pluck(:status)).to match_array(
        %w(pending cancelled_by_pension_wise)
      )
    end
  end

  it 'defaults #status to `pending`' do
    expect(described_class.new).to be_pending
  end

  it 'delegates `#reference` to the `booking_request`' do
    expect(subject.reference).to eq(subject.booking_request.reference)
  end

  it 'delegates `#activities` to the `booking_request`' do
    expect(subject.activities).to eq(subject.booking_request.activities)
  end

  it 'defaults `#created_at`' do
    expect(described_class.new.created_at).to be_present
  end

  describe '#timezone' do
    it 'returns "GMT" when the appointment is in winter time' do
      appointment = described_class.new(proceeded_at: Time.zone.parse('1 January 2017 12:00'))
      expect(appointment.timezone).to eq 'GMT'
    end

    it 'returns "BST" when the appointment is in summer time' do
      appointment = described_class.new(proceeded_at: Time.zone.parse('1 June 2017 12:00'))
      expect(appointment.timezone).to eq 'BST'
    end
  end

  describe '#fulfilment_time_seconds' do
    subject { build(:appointment) }

    it 'defaults to 0' do
      expect(described_class.new.fulfilment_time_seconds).to be_zero
    end

    context 'when the appointment date / time changes' do
      it 'is re-calculated' do
        subject.save!

        expect(subject.fulfilment_time_seconds).to eq(
          (subject.created_at.to_i - subject.booking_request.created_at.to_i).abs
        )
      end
    end
  end

  describe '#fulfilment_window_seconds' do
    subject { build(:appointment) }

    it 'defaults to 0' do
      expect(described_class.new.fulfilment_window_seconds).to be_zero
    end

    context 'when the appointment date / time changes' do
      it 'is re-calculated' do
        subject.save!

        expect(subject.fulfilment_window_seconds).to eq(
          (subject.proceeded_at.to_i - subject.booking_request.primary_slot.mid_point.to_i).abs
        )
      end
    end
  end

  describe 'auditing' do
    let(:original) { create(:appointment) }

    it 'audits changes upon update' do
      original.update(
        name: 'Dave',
        email: 'dave@example.com',
        phone: '0208 252 4729',
        proceeded_at: '2016-06-21 14:15',
        guider_id: '3'
      )

      expect(original.own_and_associated_audits).to be_present
      expect(original).to be_updated
    end

    it 'creates an activity linking to the audited entry' do
      expect { original.update(name: 'Mr. Meseeks') }.to change { original.activities.count }.by(1)
    end

    it 'does not audit changes to statistics attributes' do
      original.update(
        fulfilment_time_seconds: 1,
        fulfilment_window_seconds: 1
      )

      expect(original.own_and_associated_audits).to be_empty
    end

    describe '#notify?' do
      context 'when an associated `BookingRequest` attribute is altered' do
        before { travel_to '2016-01-01 13:00' }
        after { travel_back }

        it 'returns true' do
          original.update!(booking_request_attributes: { bsl: true })

          expect(original).to be_notify
        end
      end

      context 'when the status was changed' do
        it 'handles correctly' do
          travel_to '2016-01-01 13:00' do
            original.update(status: :completed)
            expect(original).to_not be_notify

            original.update(status: :pending)
            expect(original).to be_notify

            original.update(status: :no_show)
            expect(original).to_not be_notify
          end
        end

        context 'when the appointment has elapsed' do
          it 'is false' do
            expect(original).not_to be_notify
          end
        end
      end

      context 'when the status was not changed' do
        it 'returns true' do
          travel_to '2016-01-01 13:00' do
            original.update(name: 'George')

            expect(original).to be_notify
          end
        end
      end
    end
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    context 'when the status would require a secondary status' do
      it 'is invalid' do
        subject.status = :incomplete_other
        expect(subject).to be_invalid

        subject.secondary_status = '0' # technological issue
        expect(subject).to be_valid

        subject.secondary_status = '10' # belongs to ineligible pension type
        expect(subject).to be_invalid
      end

      context 'when the current user is an agent' do
        it 'disallows certain secondary statuses' do
          subject.current_user = build_stubbed(:agent)

          subject.status = :cancelled_by_customer
          subject.secondary_status = '15' # Cancelled prior to appointment
          expect(subject).to be_valid

          subject.secondary_status = '17' # Customer forgot
          expect(subject).to be_invalid
        end
      end

      context 'when the current user is not present' do
        it 'allows any secondary statuses' do
          subject.current_user = nil

          subject.status = :cancelled_by_customer
          subject.secondary_status = '17' # Customer forgot
          expect(subject).to be_valid
        end
      end
    end

    %i(name email phone guider_id location_id proceeded_at).each do |attribute|
      it "requires the #{attribute}" do
        subject[attribute] = ''

        expect(subject).to be_invalid
      end
    end

    it 'requires a reasonably valid email' do
      subject.email = 'meh@meh'

      expect(subject).to_not be_valid
    end

    it 'cannot overlap with an existing appointment for a given guider' do
      create(:appointment, proceeded_at: subject.proceeded_at.advance(minutes: 15))

      expect(subject).to be_invalid

      subject.guider_id = 2
      expect(subject).to be_valid
    end

    it 'does not validate overlaps for Reading specifically' do
      create(:appointment, proceeded_at: subject.proceeded_at.advance(minutes: 15))
      expect(subject).to be_invalid

      subject.location_id = 'a801a72d-91be-4a33-86a6-3d652cfc00d0'
      expect(subject).to be_valid
    end
  end
end
