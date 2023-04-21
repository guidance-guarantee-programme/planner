require 'rails_helper'

RSpec.describe AppointmentMapper, '.map' do
  let(:appointment_params) do
    {
      'guider_id'   => '1',
      'location_id' => 'deadbeef-e3cf-45cd-a8ff-9ba827b8e7ef',
      'date'        => '2016-01-01',
      'time(4i)'    => '13',
      'time(5i)'    => '00',
      'date_of_birth' => '1950-01-01',
      'memorable_word' => 'spaceship',
      'accessibility_requirements' => '1',
      'defined_contribution_pot_confirmed' => '1',
      'additional_info' => 'Additional Info'
    }
  end
  let(:appointment_form) do
    AppointmentForm.new(
      build_stubbed(:hackney_booking_request),
      appointment_params
    )
  end

  subject { described_class.map(appointment_form) }

  it 'maps from the `AppointmentForm` to `Appointment` attributes' do
    expect(subject).to match(
      name: appointment_form.name,
      email: appointment_form.email,
      phone: appointment_form.phone,
      proceeded_at: Time.zone.parse('2016-01-01 13:00'),
      guider_id: '1',
      location_id: 'deadbeef-e3cf-45cd-a8ff-9ba827b8e7ef',
      booking_request_id: appointment_form.reference,
      date_of_birth: appointment_form.date_of_birth,
      memorable_word: appointment_form.memorable_word,
      defined_contribution_pot_confirmed: appointment_form.defined_contribution_pot_confirmed,
      accessibility_requirements: appointment_form.accessibility_requirements,
      additional_info: appointment_form.additional_info,
      recording_consent: false,
      nudged: false,
      third_party: false
    )
  end
end
