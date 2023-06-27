require 'rails_helper'

RSpec.describe EmailThirdPartyConsentFormJob, '#perform' do
  context 'when no email was provided' do
    it 'does not send an email' do
      appointment = build_stubbed(:appointment)

      subject.perform(appointment)

      expect(Appointments).not_to receive(:consent_form)
    end
  end

  context 'when an email was provided' do
    let(:mailer_double) { double('mailer', deliver_now: true) }
    let(:appointment) { create(:appointment, :third_party_booking, :third_party_email_consent_form_requested) }

    before do
      allow(Appointments).to receive(:consent_form).and_return(mailer_double)
    end

    it 'generates the PDF, sends the email and logs an activity' do
      subject.perform(appointment)

      expect(Appointments).to have_received(:consent_form).with(appointment)

      expect(appointment.activities.first).to be_an(EmailThirdPartyConsentFormActivity)

      expect(appointment.generated_consent_form).to be_attached
    end
  end
end
