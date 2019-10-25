require 'rails_helper'

RSpec.describe GracePeriod do
  it 'is correct for CAS' do
    travel_to '2019-12-31'.to_date do
      cas = described_class.new(CAS_LOCATION_IDS.first)

      # this would usually be excluded as it's a bank holiday
      expect(cas.start).to eq('2020-01-03'.to_date)

      # the bank holiday is excluded for non-CAS
      expect(described_class.new('another-location-id').start).to eq('2020-01-02'.to_date)
    end
  end
end
