require 'rails_helper'

RSpec.describe BookableSlot do
  it 'is valid with valid attributes' do
    travel_to '2018-07-19 13:00 UTC' do
      expect(build(:bookable_slot)).to be_valid
    end
  end

  it 'does not allows slots to be created during exclusions' do
    slot = build(:bookable_slot)

    Exclusions::HOLIDAYS.each do |exclusion|
      slot.start_at = exclusion.to_date.end_of_day

      expect(slot).to be_invalid
    end
  end

  describe 'validations' do
    it 'does not allow overlapping slots for a particular guider' do
      @persisted = create(:bookable_slot) # 09:00 - 10:00

      # exact duplicate
      expect(build(:bookable_slot)).to be_invalid
      # intersects with the start
      expect(build(:bookable_slot, start_at: time_today('08:30'))).to be_invalid
      # intersects with the end
      expect(build(:bookable_slot, start_at: time_today('09:30'))).to be_invalid
      # overlaps at the last minute
      expect(build(:bookable_slot, start_at: time_today('10:00'))).to be_valid
    end
  end
end
