require 'rails_helper'

RSpec.describe BookableSlot do
  it 'is valid with valid attributes' do
    expect(build(:bookable_slot)).to be_valid
  end

  it 'does not allows slots to be created during exclusions' do
    slot = build(:bookable_slot)

    EXCLUSIONS.each do |exclusion|
      slot.date = exclusion

      expect(slot).to be_invalid
    end
  end
end
