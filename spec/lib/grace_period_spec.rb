require 'rails_helper'

RSpec.describe GracePeriod do
  it 'is correct' do
    travel_to '2026-02-24'.to_date do
      expect(described_class.new.start).to eq('2026-03-03'.to_date)
    end
  end
end
