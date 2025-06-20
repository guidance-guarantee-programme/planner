require 'rails_helper'

RSpec.describe BslSlotReverter, '#call' do
  it 'switches available BSL slots back to normal after 7 days' do
    travel_to '2025-06-18 13:00' do
      recent    = create(:bookable_slot, bsl: true, start_at: 1.day.from_now)
      available = create(:bookable_slot, bsl: true, start_at: 7.working.days.from_now, guider_id: 2)
      booked    = create(:bookable_slot, bsl: true, start_at: 7.working.days.from_now)
      create(:appointment, :bsl, proceeded_at: booked.start_at, guider_id: booked.guider_id)

      BslSlotReverter.new.call

      expect(booked.reload).to be_bsl
      expect(recent.reload).to be_bsl
      expect(available.reload).to_not be_bsl
    end
  end
end
