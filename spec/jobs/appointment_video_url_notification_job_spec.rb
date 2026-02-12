require 'rails_helper'

RSpec.describe AppointmentVideoUrlNotificationJob, '#perform' do
  let(:appointment) { create(:appointment) }
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

  subject { described_class.new.perform(appointment) }

  it 'sends the email and logs an activity' do
    expect(Appointments).to receive_message_chain(:customer_video_appointment, :deliver_now)

    expect { subject }.to change { VideoAppointmentUrlActivity.count }.by(1)
  end

  context 'when the appointment does not have an associated email' do
    it 'does nothing' do
      appointment.email = ''

      expect { subject }.not_to(change { VideoAppointmentUrlActivity.count })
    end
  end
end
