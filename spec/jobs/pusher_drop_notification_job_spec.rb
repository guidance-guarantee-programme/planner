require 'rails_helper'

RSpec.describe PusherDropNotificationJob, '#perform' do
  context 'when the booking request has not been fulfilled' do
    let(:booking_request) { create(:hackney_booking_request) }

    it 'sends a push notification that an email failure occurred' do
      expect(Pusher).to receive(:trigger).with(
        'drop_notifications',
        'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        {
          title: 'Email failure', fixed: true, delayOnHover: false,
          message: 'The email to morty@example.com failed to deliver',
          url: "/booking_requests/#{booking_request.id}/appointments/new"
        }
      )

      described_class.perform_now(booking_request)
    end
  end

  context 'when the booking request has been fulfilled' do
    let(:appointment) { create(:appointment) }
    let(:booking_request) { appointment.booking_request }

    it 'sends a push notification that an email failure occurred' do
      expect(Pusher).to receive(:trigger).with(
        'drop_notifications',
        'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
        {
          title: 'Email failure', fixed: true, delayOnHover: false,
          message: 'The email to morty@example.com failed to deliver',
          url: "/appointments/#{appointment.id}/edit"
        }
      )

      described_class.perform_now(booking_request)
    end
  end
end
