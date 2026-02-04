require 'rails_helper'

RSpec.describe SmsAppointmentReminderJob, '#perform' do
  let(:appointment) { create(:appointment, phone: '07715 930 444') }
  let(:client) { double(Notifications::Client, send_sms: true) }

  context 'when sending a normal appointment reminder' do
    it 'sends an SMS with the correct template and personalisation' do
      expect(client).to receive(:send_sms).with(
        phone_number: '07715 930 444',
        template_id: SmsAppointmentReminderJob::TEMPLATE_ID,
        reference: appointment.reference,
        personalisation: {
          date: '2:00pm, 20 Jun 2016',
          location: 'Hackney'
        }
      )

      described_class.new.perform(appointment)

      expect(appointment.activities.first).to be_an(SmsReminderActivity)
    end
  end

  context 'when sending a video appointment reminder' do
    let(:appointment) { create(:appointment, :video, phone: '07715 930 444') }

    it 'sends an SMS with the correct template and personalisation' do
      expect(client).to receive(:send_sms).with(
        phone_number: '07715 930 444',
        template_id: SmsAppointmentReminderJob::VIDEO_TEMPLATE_ID,
        reference: appointment.reference,
        personalisation: {
          date: '2:00pm, 20 Jun 2016',
          location: 'Hackney'
        }
      )

      described_class.new.perform(appointment)

      expect(appointment.activities.first).to be_an(SmsReminderActivity)
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
