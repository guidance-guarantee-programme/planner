require 'rails_helper'

RSpec.describe GracePeriod do
  it 'is correct for PWNI' do
    @lookup = create(:organisation_lookup, :pwni)

    travel_to '2020-03-13'.to_date do
      pwni = described_class.new(@lookup.location_id)

      # jumps past the 17th which is a holiday
      expect(pwni.start).to eq('2020-03-18'.to_date)
    end
  end

  it 'is correct for CAS' do
    @lookup = create(:organisation_lookup, :cas)

    travel_to '2020-04-08'.to_date do
      cas = described_class.new(@lookup.location_id)

      # jumps past the 10th which is a holiday and the following weekend
      expect(cas.start).to eq('2020-04-13'.to_date)
    end
  end
end
