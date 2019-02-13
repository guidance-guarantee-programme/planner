require 'rails_helper'

RSpec.describe BookableSlot do
  it 'is valid with valid attributes' do
    travel_to '2018-07-19 13:00 UTC' do
      expect(build(:bookable_slot)).to be_valid
    end
  end

  it 'does not allows slots to be created during exclusions' do
    slot = build(:bookable_slot)

    Exclusions::ALL_HOLIDAYS.each do |exclusion|
      slot.date = exclusion

      expect(slot).to be_invalid
    end
  end

  describe 'validations' do
    it 'does not allow overlapping slots for a particular guider' do
      @persisted = create(:bookable_slot, :realtime) # 09:00 - 10:00

      # exact duplicate
      expect(build(:bookable_slot, :realtime)).to be_invalid
      # intersects with the start
      expect(build(:bookable_slot, :realtime, start: '0830', end: '0930')).to be_invalid
      # intersects with the end
      expect(build(:bookable_slot, :realtime, start: '0930', end: '1030')).to be_invalid
      # overlaps at the last minute
      expect(build(:bookable_slot, :realtime, start: '1000', end: '1100')).to be_valid
    end

    context 'when mixed slots exists' do
      it 'does not permit non-realtime slots after the first realtime slot' do
        @schedule = create(:schedule, :blank)

        @schedule.create_realtime_bookable_slot!(
          start_at: 2.days.from_now,
          guider_id: 1
        )

        @slot = @schedule.bookable_slots.build(
          date: 3.days.from_now.to_date,
          start: '0900',
          end: '1300'
        )

        expect(@slot).to be_invalid

        @slot.date = 2.days.ago

        expect(@slot).to be_valid
      end
    end
  end
end
