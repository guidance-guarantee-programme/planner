require 'rails_helper'

RSpec.describe BslCustomerExitPollJob, '#perform' do
  let(:appointment) { create(:appointment) }
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

  subject { described_class.new.perform(appointment) }

  it 'sends the email and logs an activity' do
    expect(Appointments).to receive_message_chain(:bsl_customer_exit_poll, :deliver_now)

    expect { subject }.to change { BslCustomerExitPollActivity.count }.by(1)
  end
end
