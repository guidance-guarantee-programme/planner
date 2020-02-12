require 'rails_helper'

RSpec.describe AppointmentSearch do
  context 'with a blank query' do
    it 'returns an empty array' do
      expect(described_class.new('').call).to eq([])
    end
  end

  context 'with a reference number' do
    it 'returns the matching result' do
      @appointment = create(:appointment)

      expect(described_class.new(@appointment.reference).call).to eq([@appointment])
    end
  end

  context 'with a name or email' do
    it 'returns the matching results' do
      @appointment = create(:appointment, name: 'Bob Jones')
      @other       = create(:appointment, email: 'bleh@example.com', guider_id: 2)

      # by name
      expect(described_class.new('bob j').call).to eq([@appointment])
      # by email
      expect(described_class.new('bleh@exam').call).to eq([@other])
    end
  end
end
