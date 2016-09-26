require 'rails_helper'

RSpec.describe DropActivity, '.from' do
  let(:message_type) { 'customer_online_booking' }
  let(:message) { 'the message' }
  let(:booking_request) { create(:hackney_booking_request) }

  subject do
    described_class.from(message_type, message, booking_request)
  end

  context 'without a `message_type`' do
    let(:message_type) { nil }

    it 'does not include the email message type' do
      expect(subject.message).to eq('the message')
    end
  end

  context 'with a `message_type`' do
    it 'includes the email message type' do
      expect(subject.message).to eq('customer online booking - the message')
    end
  end
end
