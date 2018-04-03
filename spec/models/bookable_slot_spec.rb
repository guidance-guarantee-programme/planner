require 'rails_helper'

RSpec.describe BookableSlot do
  it 'is valid with valid attributes' do
    expect(build(:bookable_slot)).to be_valid
  end

  context 'for NICAB/CANI locations' do
    it 'does not allows slots to be created for 2018-04-09' do
      schedule = build(:schedule, :belfast_central)
      slot     = build(
        :bookable_slot,
        schedule: schedule,
        date: '2018-04-09'
      )

      expect(slot).to be_invalid
    end
  end
end
