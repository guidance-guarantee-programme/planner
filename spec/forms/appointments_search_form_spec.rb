require 'rails_helper'

RSpec.describe AppointmentsSearchForm, '#results' do
  context 'when a date range is given' do
    subject do
      described_class.new(
        appointment_date: '19/06/2016 - 21/06/2016',
        current_user: create(:hackney_booking_manager)
      )
    end

    it 'limits results to within those dates' do
      present = create(:appointment)
      create(:appointment, proceeded_at: 3.years.ago)

      expect(subject.results).to contain_exactly(present)
    end
  end
end
