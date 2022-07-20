require 'rails_helper'

RSpec.describe GracePeriod do
  it 'is correct for PWNI' do
    @lookup = create(:organisation_lookup, :pwni)

    travel_to '2022-08-25'.to_date do
      pwni = described_class.new(@lookup.location_id)

      # jumps past the holiday
      expect(pwni.start).to eq('2022-08-31'.to_date)
    end
  end

  it 'is correct for CAS' do
    @lookup = create(:organisation_lookup, :cas)

    travel_to '2022-08-25'.to_date do
      cas = described_class.new(@lookup.location_id)

      # lands on an English/Welsh bank holiday
      expect(cas.start).to eq('2022-08-31'.to_date)
    end
  end
end
