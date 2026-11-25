require 'rails_helper'

RSpec.describe Qualtrics::Presenters::Appointment, '#to_h' do
  let(:appointment) do
    double(
      :appointment,
      reference: 999,
      first_name: 'Bob',
      last_name: 'Smith',
      email: 'bob@example.com',
      phone: '07715930459',
      bsl_video?: false,
      video_appointment?: false
    )
  end

  subject { described_class.new(appointment) }

  it 'maps the standard attributes' do
    expect(subject.to_h).to include(
      reference: 999,
      first_name: 'Bob',
      last_name: 'Smith',
      email: 'bob@example.com',
      mobile: '07715930459'
    )
  end

  it 'maps the type' do
    expect(subject.to_h).to include(type: 'f2f-location')

    allow(appointment).to receive(:bsl_video?).and_return(true)
    expect(subject.to_h).to include(type: 'f2f-bsl-video')

    allow(appointment).to receive(:bsl_video?).and_return(false)
    allow(appointment).to receive(:video_appointment?).and_return(true)
    expect(subject.to_h).to include(type: 'f2f-video')
  end
end
