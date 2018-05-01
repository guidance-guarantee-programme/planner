require 'rails_helper'

RSpec.describe DropNotificationJob, '#perform' do
  let(:booking_request) { create(:hackney_booking_request) }

  subject { described_class.new.perform(booking_request) }

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
end
