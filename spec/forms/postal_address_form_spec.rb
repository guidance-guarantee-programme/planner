require 'rails_helper'

RSpec.describe PostalAddressForm do
  let(:agent) { build(:agent) }
  let(:booking_request) { build(:postal_booking_request, agent: agent) }

  subject { described_class.new(booking_request) }

  it 'validates the presence of address_line_one' do
    subject.address_line_one = ''

    expect(subject).not_to be_valid
    expect(subject.errors[:address_line_one]).to include("can't be blank")
  end

  it 'validates the presence of town' do
    subject.town = ''

    expect(subject).not_to be_valid
    expect(subject.errors[:town]).to include("can't be blank")
  end

  it 'validates the presence of postcode' do
    subject.postcode = ''

    expect(subject).not_to be_valid
    expect(subject.errors[:postcode]).to include("can't be blank")
  end
end
