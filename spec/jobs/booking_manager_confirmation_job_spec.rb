require 'rails_helper'

RSpec.describe BookingManagerConfirmationJob, '#perform' do
  let(:booking_request) { create(:hackney_booking_request) }
  let(:appointment) { create(:appointment) }

  subject { described_class.new.perform(booking_request) }

  context 'when the booking belongs to CAS' do
    let(:booking_request) { create(:drumchapel_booking_request) }

    it 'sends a single notification to their alias' do
      expect(BookingRequests).to receive(:booking_manager).with(
        booking_request,
        Appointment::CAS_BOOKING_MANAGER_ALIAS
      ).and_return(double(deliver_later: true))

      subject
    end
  end

  context 'when the booking manager(s) cannot be found' do
    it 'raises an error thus forcing retries' do
      expect { subject }.to raise_error(BookingManagersNotFoundError)
    end
  end

  context 'when booking manager(s) are found' do
    before { create(:hackney_booking_manager) }

    it 'fans out a notification job for each booking manager' do
      assert_enqueued_jobs(1) { subject }
    end
  end

  context 'with only inactive booking managers' do
    before { create(:hackney_booking_manager, disabled: true) }

    it 'raises an error' do
      expect { subject }.to raise_error(BookingManagersNotFoundError)
    end
  end

  context 'with organisation members that are not booking managers' do
    before { create(:user, organisation_content_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

    it 'raises an error' do
      expect { subject }.to raise_error(BookingManagersNotFoundError)
    end
  end

  context 'when the booking has an appointment associated' do
    let(:booking_manager) { create(:hackney_booking_manager) }

    it 'passes the appointment on to the mailer' do
      expect(BookingRequests).to receive(:booking_manager)
        .with(appointment, booking_manager.email)
        .and_return(double.as_null_object)

      described_class.new.perform(appointment.booking_request)
    end
  end
end
