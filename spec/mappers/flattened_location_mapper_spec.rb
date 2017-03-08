require 'rails_helper'

RSpec.describe FlattenedLocationMapper, '.map' do
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

  subject { described_class.map(hackney) }

  it 'returns the list of flattened locations' do
    expect(subject).to match_array(
      [
        ['Hackney', 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'],
        ['Dalston', '183080c6-642b-4b8f-96fd-891f5cd9f9c7'],
        ['Tower Hamlets', '1a1ad00f-d967-448a-a4a6-772369fa5087'],
        ['Haringey', 'c165d25e-f27b-4ce9-b3d3-e7415ebaa93c'],
        ['Enfield', '1cc67bbb-b879-4def-8713-99255a0bce03'],
        ['Newham', '89821b79-b132-4893-bc9f-c247dd9009fd']
      ]
    )
  end
end
