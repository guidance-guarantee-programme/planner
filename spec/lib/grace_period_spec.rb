require 'rails_helper'

RSpec.describe GracePeriod do
  it 'is correct for CAS' do
    travel_to '2019-04-17'.to_date do
      cas = described_class.new(CAS_LOCATION_IDS.first)

      # this would usually be excluded as it's a bank holiday
      expect(cas.start).to eq('2019-04-19'.to_date)

      # the bank hoiday is excluded for non-CAS
      expect(described_class.new('another-location-id').start).to eq('2019-04-22'.to_date)
    end
  end
end
