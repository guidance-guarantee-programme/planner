require 'rails_helper'

RSpec.describe GuiderLookup, '.populate' do
  it 'retrieves the guiders for existing appointment booking locations' do
    @appointment = create(:appointment)

    described_class.populate

    expect(described_class.first).to have_attributes(
      guider_id: 1,
      name: 'Ben Lovell',
      booking_location_id: @appointment.booking_request.booking_location_id
    )
  end
end
