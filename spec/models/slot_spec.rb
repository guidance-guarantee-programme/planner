require 'rails_helper'

RSpec.describe Slot do
  describe '#morning?' do
    context 'when the slot starts before 1300' do
      it 'is true' do
        expect(Slot.new(from: '0900')).to be_morning
      end
    end

    context 'when the slot starts after 1300' do
      it 'is false' do
        expect(Slot.new(from: '1300')).to_not be_morning
      end
    end
  end

  describe '#to_s' do
    it 'describes the slot' do
      slot = Slot.new(
        date: Date.parse('2016-01-01'),
        from: '0900',
        to: '1300'
      )

      expect(slot.to_s).to eq('1 January 2016 - morning')
    end
  end
end
