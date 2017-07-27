require 'rails_helper'

RSpec.describe ScheduleRegeneration do
  describe '#scheduled_for_generation' do
    it 'returns schedules with their final slot at the end of the booking window' do
      # this will be present
      @schedule = create(:schedule) do |schedule|
        create(:bookable_slot, :am, date: 8.weeks.from_now, schedule: schedule)
      end

      # this won't since it is blank
      @blank = create(:schedule, :blank)

      # this won't since the last slot is not today
      @other = create(:schedule, :dalston, :blank, monday_am: true, &:generate_bookable_slots!)

      expect(subject.schedules_for_regeneration).to match_array(@schedule)
    end
  end
end
