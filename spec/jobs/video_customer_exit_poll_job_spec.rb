require 'rails_helper'

RSpec.describe VideoCustomerExitPollJob, '#perform' do
  let(:appointment) { create(:appointment, :video) }

  subject { described_class.new.perform(appointment) }

  it 'sends the email and logs an activity' do
    expect(Appointments).to receive_message_chain(:video_customer_exit_poll, :deliver_now)

    expect { subject }.to change { VideoCustomerExitPollActivity.count }.by(1)
  end

  context 'when the appointment does not have an associated email' do
    it 'does nothing' do
      appointment.email = ''

      expect { subject }.not_to(change { VideoCustomerExitPollActivity.count })
    end
  end
end
