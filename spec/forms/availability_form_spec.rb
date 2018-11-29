require 'rails_helper'

RSpec.describe AvailabilityForm, '#upsert!' do
  it 'does not destroy realtime slots' do
    realtime = create(:bookable_slot, :realtime)

    described_class
      .new(date: '2018-07-14', am: true, pm: true, schedule_id: realtime.schedule_id)
      .upsert!

    expect(realtime.reload).to be_persisted
  end
end
