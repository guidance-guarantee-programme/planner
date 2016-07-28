require 'rails_helper'

RSpec.describe LocationAwareEntities do
  let(:booking_requests) { Array(build(:booking_request)) }
  let(:booking_location) { instance_double(BookingLocations::Location) }

  subject { described_class.new(booking_requests, booking_location) }

  describe '#all' do
    it 'returns decorated booking requests' do
      expect(subject.all.map(&:class)).to match_array(LocationAwareEntity)
    end
  end
end
