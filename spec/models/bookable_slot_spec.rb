require 'rails_helper'

RSpec.describe BookableSlot do
  it 'is valid with valid attributes' do
    travel_to '2018-07-19 13:00 UTC' do
      expect(build(:bookable_slot)).to be_valid
    end
  end

  it 'does not allows slots to be created during exclusions' do
    slot = build(:bookable_slot)

    EXCLUSIONS.each do |exclusion|
      slot.date = exclusion

      expect(slot).to be_invalid
    end
  end

  describe 'validations' do
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
