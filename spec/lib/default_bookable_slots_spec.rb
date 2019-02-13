require 'rails_helper'

RSpec.describe DefaultBookableSlots do
  before { travel_to('2017-05-25 13:00 UTC') }
  after { travel_back }

  subject { described_class.new(location_id: 'bleh') }

  let(:slots) { subject.call }

  it 'defaults the booking window to 6 weeks' do
    expect(subject.from).to eq(Date.current)
    expect(subject.to).to eq(6.weeks.from_now.to_date)
  end

  it 'returns slots in the booking window' do
    # advanced to the grace period and exclude the bank holiday
    expect(slots.first.date).to eq('2017-05-30')
    # the end of the booking window
    expect(slots.last.date).to eq('2017-07-06')
  end

  it 'doesn’t include weekends' do
    weekends = slots.select { |slot| slot.date.to_date.on_weekend? }

    expect(weekends).to be_empty
  end

  it 'is always non-realtime' do
    expect(slots.none?(&:realtime?)).to be_truthy
  end
end
