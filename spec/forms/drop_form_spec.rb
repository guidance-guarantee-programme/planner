require 'rails_helper'

RSpec.describe DropForm, '#create_activity' do
  let!(:booking_request) { create(:hackney_booking_request) }
  let(:params) do
    {
      'event' => 'dropped',
      'recipient' => 'morty@example.com',
      'description' => 'the reasoning',
      'message_type' => 'customer_booking_request',
      'environment' => 'production',
      'online_booking' => true,
      'timestamp' => '1474638633',
      'token' => 'secret',
      'signature' => 'abf02bef01e803bea52213cb092a31dc2174f63bcc2382ba25732f4c84e084c1'
    }
  end
  let(:token) { 'deadbeef' }

  around do |example|
    begin
      existing = ENV['MAILGUN_API_TOKEN']

      ENV['MAILGUN_API_TOKEN'] = token
      example.run
    ensure
      ENV['MAILGUN_API_TOKEN'] = existing
    end
  end

  subject { described_class.new(params) }

  context 'when the signature is not verified' do
    it 'raises an error' do
      params['signature'] = 'whoops'

      expect { subject.create_activity }.to raise_error(TokenVerificationFailure)
    end
  end

  context 'when the signature is verified' do
    DropForm::INTERESTING_MESSAGE_TYPES.each do |message_type|
      it "is valid with #{message_type}" do
        params['message_type'] = message_type

        expect(subject).to be_valid
      end
    end

    it 'only cares about customer message types' do
      params['message_type'] = 'sms_appointment_cancellation'

      expect(subject).not_to be_valid
    end

    it 'requires a booking request' do
      params['recipient'] = 'meh@example.com'

      expect(subject).not_to be_valid
    end

    it 'requires the production environment' do
      params['environment'] = 'staging'

      expect(subject).not_to be_valid
    end

    it 'must originate from online booking' do
      params.delete('online_booking')

      expect(subject).not_to be_valid
    end

    context 'when everything is validated' do
      it 'creates the drop activity' do
        expect(DropActivity).to receive(:from).with(
          params['message_type'],
          params['description'],
          booking_request
        )

        subject.create_activity
      end
    end
  end
end
