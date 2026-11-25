require 'rails_helper'

RSpec.describe QualtricsAppointmentBookedJob, '#perform' do
  let(:api_double) { instance_double(Qualtrics::Api, appointment_booked: true) }

  context 'when the appointment is opted-in' do
    it 'calls the correct Qualtrics API' do
      appointment = build(:appointment)

      allow(Qualtrics::Api).to receive(:new).and_return(api_double)

      described_class.new.perform(appointment)

      expect(api_double).to have_received(:appointment_booked)
    end
  end

  context 'when the appointment is opted-out' do
    it 'does not call the Qualtrics API' do
      appointment = double(:appointment, survey_consent?: false)

      described_class.new.perform(appointment)

      expect(api_double).not_to have_received(:appointment_booked)
    end
  end
end
