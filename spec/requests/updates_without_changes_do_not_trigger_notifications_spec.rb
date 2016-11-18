require 'rails_helper'

RSpec.describe 'Updates without changes' do
  before do
    @booking_manager = create(:hackney_booking_manager)
    @appointment     = create(:appointment)
  end

  let(:params) do
    Hash[appointment: { status: 'pending' }]
  end

  it 'do not trigger notifications' do
    perform_enqueued_jobs do
      patch appointment_path(@appointment), params: params

      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
