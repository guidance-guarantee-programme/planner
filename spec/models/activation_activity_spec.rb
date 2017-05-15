require 'rails_helper'

RSpec.describe ActivationActivity, '.from' do
  let(:initiator) { create(:user) }

  subject { described_class.from(booking_request, initiator, reason) }

  context 'with no reason provided' do
    let(:status) { BookingRequest.statuses.keys.first }
    let(:reason) { nil }
    let(:booking_request) { create(:booking_request, status: status) }

    it 'sets the message to just the status' do
      expect(subject.message).to eq(status)
    end
  end

  context 'with reason provided' do
    let(:status) { BookingRequest.statuses.keys.first }
    let(:reason) { 'reason for status change' }
    let(:booking_request) { create(:booking_request, status: status) }

    it 'sets builds a message from the status and reason' do
      expect(subject.message).to eq("'#{status}', reason given '#{reason}'")
    end
  end
end
