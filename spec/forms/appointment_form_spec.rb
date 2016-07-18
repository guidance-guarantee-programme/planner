require 'rails_helper'

RSpec.describe AppointmentForm do
  let(:booking_request) { build_stubbed(:booking_request) }
  let(:params) { Hash.new }

  subject { described_class.new(booking_request, params) }

  it 'delegates booking specifics to the booking request' do
    expect(subject.name).to eq(booking_request.name)
    expect(subject.email).to eq(booking_request.email)
    expect(subject.phone).to eq(booking_request.phone)
    expect(subject.age_range).to eq(booking_request.age_range)
    expect(subject.reference).to eq(booking_request.reference)
    expect(subject.location_id).to eq(booking_request.location_id)
    expect(subject.memorable_word).to eq(booking_request.memorable_word)
    expect(subject.accessibility_requirements).to eq(booking_request.accessibility_requirements)
  end
end
