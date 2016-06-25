require 'rails_helper'

RSpec.describe BookingRequest do
  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(build(:booking_request)).to be_valid
    end

    it 'requires a location_id' do
      expect(build(:booking_request, location_id: '')).to_not be_valid
    end

    it 'requires a name' do
      expect(build(:booking_request, name: '')).to_not be_valid
    end

    it 'requires an email' do
      expect(build(:booking_request, email: '')).to_not be_valid
    end

    it 'requires a phone' do
      expect(build(:booking_request, phone: '')).to_not be_valid
    end

    it 'requires a memorable word' do
      expect(build(:booking_request, memorable_word: '')).to_not be_valid
    end

    it 'requires a permitted age range' do
      booking_request = build(:booking_request, age_range: '')
      expect(booking_request).to_not be_valid

      booking_request.age_range = 'whoops'
      expect(booking_request).to_not be_valid
    end

    it 'requires accessibility_requirements' do
      expect(build(:booking_request, accessibility_requirements: '')).to_not be_valid
    end

    it 'requires marketing_opt_in' do
      expect(build(:booking_request, marketing_opt_in: '')).to_not be_valid
    end

    it 'requires defined_contribution_pot' do
      expect(build(:booking_request, defined_contribution_pot: '')).to_not be_valid
    end

    it 'requires 3 slots' do
      build(:booking_request) do |booking|
        booking.slots.clear

        expect(booking).to_not be_valid
      end
    end

    it 'requires one slot of each permitted priority' do
      build(:booking_request) do |booking|
        booking.slots << build(:slot)

        expect(booking).to_not be_valid
      end
    end
  end

  describe '#reference' do
    it 'returns the #id as a string' do
      booking = BookingRequest.new(id: 1)

      expect(booking.id.to_s).to eq(booking.reference)
    end
  end

  describe '#slots' do
    it 'is returned in order of #priority' do
      request = create(:booking_request)

      expect(request.slots.pluck(:priority)).to eq([1, 2, 3])
    end
  end
end
