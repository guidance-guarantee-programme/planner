require 'rails_helper'

RSpec.describe AppointmentMailActivity, '.from' do
  let(:booking_request) { create(:booking_request) }
  let(:appointment) { create(:appointment, booking_request: booking_request) }

  subject { described_class.from(appointment) }

  context 'when the appointment is a new booking' do
    before { allow(appointment).to receive(:updated?) { false } }

    it 'sets the message correctly' do
      expect(subject.message).to eq('booked')
    end
  end

  context 'when the appointment has been updated' do
    before { allow(appointment).to receive(:updated?) { true } }

    it 'sets the message correctly' do
      expect(subject.message).to eq('updated')
    end
  end

  context 'when the appointment has been cancelled' do
    before { allow(appointment).to receive(:cancelled?) { true } }

    it 'sets the message correctly' do
      expect(subject.message).to eq('cancelled')
    end
  end
end
