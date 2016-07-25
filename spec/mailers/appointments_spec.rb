require 'rails_helper'

RSpec.describe Appointments do
  let(:appointment) { build_stubbed(:appointment) }
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

  subject(:mail) { described_class.customer(appointment, hackney) }

  describe 'Customer notification' do
    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include('2:00pm, 20 June 2016')
        expect(body).to include('Hackney')
        expect(body).to include('+443344556677')
        expect(body).to include("reference number, #{appointment.reference}")
      end

      it 'includes the guider' do
        expect(body).to include('Ben Lovell')
      end

      it 'includes the address' do
        expect(body).to include(
          '300 Mare St',
          'HACKNEY',
          'London',
          'E8 1HE'
        )
      end
    end
  end
end
