require 'rails_helper'

RSpec.describe AppointmentHelper do
  describe '.appointment_duration' do
    context 'for BSL appointments' do
      it 'returns the correct duration' do
        booking = double(BookingRequest, bsl?: true)

        expect(helper.appointment_duration(booking)).to eq('90')
      end
    end

    context 'for regular appointments' do
      it 'returns the correct duration' do
        booking = double(BookingRequest, bsl?: false)

        expect(helper.appointment_duration(booking)).to eq('60')
      end
    end
  end
end
