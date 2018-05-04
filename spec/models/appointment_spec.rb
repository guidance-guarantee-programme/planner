require 'rails_helper'

RSpec.describe Appointment do
  subject { build_stubbed(:appointment) }

  describe '.needing_reminder' do
    context 'with an appointment 7 days in the future' do
      it 'is included correctly based on its status' do
        appointment = create(:appointment, proceeded_at: 7.days.from_now)

        expect(described_class.needing_reminder).to include(appointment)

        appointment.update(status: :cancelled_by_customer)

        expect(described_class.needing_reminder).to be_empty
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

      expect(original.audits).to be_present
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

      expect(original.audits).to be_empty
    end

    describe '#notify?' do
      context 'when the status was changed' do
        it 'handles correctly' do
          original.update(status: :completed)
          expect(original).to_not be_notify

          original.update(status: :pending)
          expect(original).to be_notify
        end
      end

      context 'when the status was not changed' do
        it 'returns true' do
          original.update(name: 'George')

          expect(original).to be_notify
        end
      end
    end
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
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
  end
end
