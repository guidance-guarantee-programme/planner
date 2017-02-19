require 'rails_helper'

RSpec.describe BookingManagerConfirmationJob, '#perform' do
  let(:booking_request)  { double(location_id: 'whelp') }
  let(:booking_location) { double(id: 'badbeef') }

  before do
    allow(BookingLocations).to receive(:find).and_return(booking_location)
  end

  subject { described_class.new.perform(booking_request) }

  context 'when the booking manager(s) cannot be found' do
    it 'raises an error thus forcing retries' do
      expect { subject }.to raise_error(BookingManagersNotFoundError)
    end
  end

  context 'when booking manager(s) are found' do
    before { create(:hackney_booking_manager) }

    let(:booking_location) { double(id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

    it 'fans out a notification job for each booking manager' do
      assert_enqueued_jobs(1) { subject }
    end
  end

  context 'with only inactive booking managers' do
    before { create(:hackney_booking_manager, disabled: true) }

    let(:booking_location) { double(id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

    it 'raises an error' do
      expect { subject }.to raise_error(BookingManagersNotFoundError)
    end
  end
end
