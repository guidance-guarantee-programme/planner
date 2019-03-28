require 'rails_helper'

RSpec.describe Schedule do
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

  describe '#unavailable?' do
    context 'with a default schedule' do
      it 'is true' do
        expect(described_class.new).to be_unavailable
      end
    end

    context 'with an empty schedule' do
      it 'is true' do
        @schedule = create(:schedule)

        expect(@schedule).to be_unavailable
      end
    end
  end

  describe '#generate_bookable_slots!' do
    before do
      travel_to '2017-07-19 13:00 UTC'

      @previous_schedule = create(:schedule) do |schedule|
        create(:bookable_slot, :am, schedule: schedule)
      end

      @other_schedule = create(:schedule, location_id: 'deadbeef') do |schedule|
        create(:bookable_slot, :am, schedule: schedule)
      end

      @current_schedule = create(:schedule, monday_am: true, friday_pm: true)
    end

    after { travel_back }

    it 'performs the requisite steps to generate bookable slots' do
      @current_schedule.generate_bookable_slots!
      # deleted slots from the schedule start date, for the same location
      expect(@previous_schedule.bookable_slots).to be_empty
      # other location's slots are left intact
      expect(@other_schedule.bookable_slots).to_not be_empty

      # created slots based on the scheduled availability
      mondays, fridays = @current_schedule.bookable_slots.partition do |slot|
        slot.date.strftime('%A') == 'Monday'
      end

      expect(mondays.all?(&:am?))
      expect(fridays.all?(&:pm?))
    end
  end

  describe '.current' do
    context 'when multiple schedules exist for a single location' do
      it 'returns the latest one' do
        # first, default schedule
        create(:schedule)
        # the current schedule
        create(:schedule, monday_am: false)

        expect(described_class.current(hackney.id)).to_not be_monday_am
      end
    end

    context 'when no schedules exist' do
      it 'returns a default schedule' do
        expect(described_class.current(hackney.id)).to be_unavailable
      end
    end
  end
end
