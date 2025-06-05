require 'rails_helper'

RSpec.describe EditAppointmentForm do
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }
  let(:underlying_appointment) { create(:appointment) }
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

  it 'delegates the agent to the underlying booking request' do
    expect(subject.agent).to eq(appointment.booking_request.agent)
  end

  it 'delegates the adjustments' do
    appointment.booking_request.adjustments = 'These are them'

    expect(subject.adjustments).to eq('These are them')
  end

  context 'when no underlying slot exists after reallocation' do
    it 'creates the missing realtime slot' do
      # creates the missing slot
      expect { subject.update(proceeded_at: '2019-05-22 13:00 UTC') }.to change { BookableSlot.count }.by(1)

      # doesn't create another, overlapping slot
      expect { subject.update(proceeded_at: '2019-05-22 12:45 UTC') }.not_to(change { BookableSlot.count })

      # creates another slot for the guider change
      expect { subject.update(guider_id: 2) }.to change { BookableSlot.count }.by(1)

      # creates another slot for the location and date change
      expect do
        subject.update(location_id: '183080c6-642b-4b8f-96fd-891f5cd9f9c7', proceeded_at: '2019-05-22 14:15 UTC')
      end.to change { BookableSlot.count }.by(1)
    end
  end
end
