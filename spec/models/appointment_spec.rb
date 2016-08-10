require 'rails_helper'

RSpec.describe Appointment do
  subject { build_stubbed(:appointment) }

  it 'defaults #status to `pending`' do
    expect(described_class.new).to be_pending
  end

  it 'delegates `#reference` to the `booking_request`' do
    expect(subject.reference).to eq(subject.booking_request.reference)
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
          subject.proceeded_at.to_i - subject.booking_request.created_at.to_i
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
          subject.proceeded_at.to_i - subject.booking_request.primary_slot.mid_point.to_i
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

    describe '#notify?' do
      context 'when the status was changed' do
        it 'returns false' do
          original.update(status: 1)

          expect(original).to_not be_notify
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
  end
end
