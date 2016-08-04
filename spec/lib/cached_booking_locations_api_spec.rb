require 'rails_helper'
require_relative '../../lib/cached_booking_locations_api'

RSpec.describe CachedBookingLocationsApi do
  let(:location_id) { 'birdperson' }
  let(:booking_locations_api) { double }
  let(:location) { 'location' }

  subject { described_class.new(booking_locations_api: booking_locations_api) }

  before { Rails.cache.clear }

  it 'caches the result after the first call yields' do
    expect(booking_locations_api).to receive(:get)
      .once
      .with(location_id)
      .and_return(location)

    expect(subject.get(location_id)).to eq(location)

    # trigger the second call, this response is cached now
    subject.get(location_id)
  end
end
