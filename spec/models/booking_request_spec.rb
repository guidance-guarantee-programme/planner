require 'rails_helper'

RSpec.describe BookingRequest do
  describe '#reference' do
    it 'returns the #id as a string' do
      booking = BookingRequest.new(id: 1)

      expect(booking.id.to_s).to eq(booking.reference)
    end
  end

  describe '#slots' do
    it 'is returned in order of #priority' do
      request = create(:booking_request_with_slots)

      expect(request.slots.pluck(:priority)).to eq([1, 2, 3])
    end
  end
end
