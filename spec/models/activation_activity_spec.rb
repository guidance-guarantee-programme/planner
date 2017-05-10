require 'rails_helper'

RSpec.describe ActivationActivity, '.from' do
  let(:initiator) { create(:user) }

  subject { described_class.from(booking_request, initiator) }

  context 'with an active booking' do
    let(:booking_request) { create(:booking_request) }

    it 'sets the message correctly' do
      expect(subject.message).to eq('active')
    end
  end

  context 'with a hidden booking' do
    let(:booking_request) { create(:booking_request, status: :hidden) }

    it 'sets the message correctly' do
      expect(subject.message).to eq('inactive')
    end
  end
end
