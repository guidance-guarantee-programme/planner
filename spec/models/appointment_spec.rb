require 'rails_helper'

RSpec.describe Appointment do
  let(:appointment) { build_stubbed(:appointment) }

  it 'delegates `#reference` to the `booking_request`' do
    expect(appointment.reference).to eq(appointment.booking_request.reference)
  end
end
