require 'rails_helper'

RSpec.describe Schedule do
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

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
        expect(described_class.current(hackney.id)).to_not be_persisted
      end
    end
  end
end
