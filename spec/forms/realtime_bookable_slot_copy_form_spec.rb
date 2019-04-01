require 'rails_helper'

RSpec.describe RealtimeBookableSlotCopyForm do
  subject do
    described_class.new(
      guider_id: 1,
      date: '2025/01/01',
      date_range: '2025/01/01 - 2025/01/07',
      location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      day_ids: [1, 2, 3],
      slots: ['2025/01/01 13:00 UTC']
    )
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'requires selected days' do
      subject.day_ids = []

      expect(subject).to be_invalid
    end

    it 'requires selected slots' do
      subject.slots = []

      expect(subject).to be_invalid
    end

    it 'requires a chosen date range' do
      subject.date_range = ''

      expect(subject).to be_invalid
    end
  end
end
