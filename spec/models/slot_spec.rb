require 'rails_helper'

RSpec.describe Slot do
  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(build(:slot)).to be_valid
    end

    it 'requires a permitted priority' do
      expect(build(:slot, priority: 4)).to_not be_valid
    end

    it 'requires a date' do
      expect(build(:slot, date: '')).to_not be_valid
    end

    it 'requires a correctly formatted from' do
      expect(build(:slot, from: 'nope')).to_not be_valid
    end

    it 'requires a correctly formatted to' do
      expect(build(:slot, to: 'welp')).to_not be_valid
    end

    it 'requires from to be before to' do
      expect(build(:slot, from: '1300', to: '0900')).to_not be_valid
    end
  end

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

  describe '#mid_point' do
    subject { Slot.new(from: from, date: '2016-01-01').mid_point.to_s(:db) }

    context 'for a morning slot' do
      let(:from) { '0900' }

      it 'returns the mid-morning' do
        expect(subject).to eq('2016-01-01 11:00:00')
      end
    end

    context 'for an afternoon slot' do
      let(:from) { '1300' }

      it 'returns the mid-afternoon' do
        expect(subject).to eq('2016-01-01 15:00:00')
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

      expect(slot.to_s).to eq('1 January 2016 - Morning')
    end
  end
end
