require 'rails_helper'

RSpec.describe EditAppointmentForm do
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }
  let(:underlying_appointment) { build_stubbed(:appointment) }
  let(:appointment) do
    LocationAwareEntity.new(
      entity: underlying_appointment,
      booking_location: hackney
    )
  end

  subject { described_class.new(appointment) }

  it 'delegates slots to the underlying booking request' do
    expect(subject.primary_slot).to eq(appointment.booking_request.primary_slot)
    expect(subject.secondary_slot).to eq(appointment.booking_request.secondary_slot)
    expect(subject.tertiary_slot).to eq(appointment.booking_request.tertiary_slot)
  end
end
