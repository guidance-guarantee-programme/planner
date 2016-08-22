require 'rails_helper'

RSpec.describe AuditActivity do
  describe '.from' do
    before do
      @appointment = create(:appointment).tap do |a|
        # this will trigger the `after_audit` hook on `Appointment`
        a.update(
          name: 'Dave Jones',
          email: 'dj@dj.com',
          phone: '07715 930 455'
        )
      end
    end

    let(:audit) { @appointment.audits.last }

    subject { @appointment.activities.last }

    it 'creates an audit activity from the given audit' do
      expect(subject).to be_a(described_class)

      expect(subject).to have_attributes(
        user_id: audit.user_id,
        booking_request_id: @appointment.booking_request.id,
        message: 'name, email, and phone'
      )
    end
  end
end
