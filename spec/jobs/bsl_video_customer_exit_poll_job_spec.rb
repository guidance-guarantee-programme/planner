require 'rails_helper'

RSpec.describe BslVideoCustomerExitPollJob, '#perform' do
  let(:appointment) { create(:appointment, :video, :bsl) }

  subject { described_class.new.perform(appointment) }

  it 'sends the email and logs an activity' do
    expect(Appointments).to receive_message_chain(:bsl_video_customer_exit_poll, :deliver_now)

    expect { subject }.to change { BslVideoCustomerExitPollActivity.count }.by(1)
  end

  context 'when the appointment does not have an associated email' do
    it 'does nothing' do
      appointment.email = ''

      expect { subject }.not_to(change { BslVideoCustomerExitPollActivity.count })
    end
  end
end
