require 'rails_helper'

RSpec.describe OrganisationLookup, '.populate' do
  it 'retrieves the organisations for existing appointment locations' do
    @appointment = create(:appointment)

    described_class.populate

    expect(described_class.first).to have_attributes(
      location_id: @appointment.location_id,
      organisation: 'cita'
    )
  end
end
