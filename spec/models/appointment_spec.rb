require 'rails_helper'

RSpec.describe Appointment do
  let(:appointment) { build_stubbed(:appointment) }

  it 'defaults #status to `pending`' do
    expect(described_class.new).to be_pending
  end

  it 'delegates `#reference` to the `booking_request`' do
    expect(appointment.reference).to eq(appointment.booking_request.reference)
  end

  it 'audits changes upon update' do
    original = create(:appointment)

    original.update(
      name: 'Dave',
      email: 'dave@example.com',
      phone: '0208 252 4729',
      proceeded_at: '2016-06-21 14:15',
      guider_id: '3'
    )

    expect(original.audits).to be_present
  end
end
