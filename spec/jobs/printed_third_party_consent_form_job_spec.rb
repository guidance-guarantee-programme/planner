require 'rails_helper'

RSpec.describe PrintedThirdPartyConsentFormJob, '#perform' do
  let(:appointment) { build_stubbed(:appointment) }
  let(:client) { double(Notifications::Client, send_letter: true) }

  context 'when no consent form required' do
    it 'does not send a letter' do
      expect(client).to_not receive(:send_letter)

      described_class.new.perform(appointment)
    end
  end

  context 'when a consent form is required' do
    let(:appointment) { create(:appointment, :third_party_booking, :third_party_consent_form_requested) }

    it 'sends an letter' do
      expect(client).to receive(:send_letter).with(
        template_id: PrintedThirdPartyConsentFormJob::TEMPLATE_ID,
        reference: appointment.reference,
        personalisation: {
          reference: appointment.reference,
          third_party_name: appointment.name,
          address_line_1: appointment.booking_request.data_subject_name,
          address_line_2: '1 Some Street',
          address_line_3: 'Some Place',
          address_line_4: 'Somewhere',
          address_line_5: 'Some Town',
          address_line_6: 'Some County',
          address_line_7: 'SS1 1SS'
        }
      )

      described_class.new.perform(appointment)

      expect(appointment.activities.first).to be_an(PrintedThirdPartyConsentFormActivity)
    end
  end

  before do
    ENV['NOTIFY_API_KEY'] = 'blahblah'

    allow(Notifications::Client).to receive(:new).and_return(client)
  end

  after do
    ENV.delete('NOTIFY_API_KEY')
  end
end
