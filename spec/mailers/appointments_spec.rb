require 'rails_helper'

RSpec.describe Appointments do
  let(:appointment) do
    build_stubbed(:appointment, location_id: '183080c6-642b-4b8f-96fd-891f5cd9f9c7')
  end
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

  describe 'SMS cancellation' do
    let(:booking_manager) { create(:hackney_booking_manager) }

    subject(:mail) { described_class.booking_manager_cancellation(booking_manager, appointment) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Pension Wise Appointment SMS Cancellation')
      expect(mail.to).to eq([booking_manager.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include(appointment.reference)
        expect(body).to include("/appointments/#{appointment.id}/edit")
      end
    end
  end

  describe 'Customer reminder' do
    subject(:mail) { described_class.reminder(appointment, hackney) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment Reminder')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
      expect(mail.reply_to).to eq(['dave@example.com'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include('2:00pm')
        expect(body).to include('20 June 2016')
        expect(body).to include('Dalston')
        expect(body).to include('0800123456')
        expect(body).to include(appointment.reference)
      end

      it 'includes the guider first name' do
        expect(body).to include('Ben')
      end

      it 'includes the address' do
        expect(body).to include(
          '22 Dalston Lane',
          'Hackney',
          'London',
          'E8 3AZ'
        )
      end
    end
  end

  describe 'Customer notification' do
    subject(:mail) { described_class.customer(appointment, hackney) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
      expect(mail.reply_to).to eq(['dave@example.com'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include('2:00pm')
        expect(body).to include('20 June 2016')
        expect(body).to include('Dalston')
        expect(body).to include('0800123456')
        expect(body).to include(appointment.reference)
      end

      it 'includes the guider first name' do
        expect(body).to include('Ben')
      end

      it 'includes the address' do
        expect(body).to include(
          '22 Dalston Lane',
          'Hackney',
          'London',
          'E8 3AZ'
        )
      end

      context 'when sending the initial appointment notification' do
        it 'does not include the lead paragraph for updates' do
          expect(body).to_not include('Your appointment details were updated')
        end

        it 'identifies the message correctly' do
          expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"appointment_confirmation"')
        end
      end

      context 'when sending the updated appointment notification' do
        before { allow(appointment).to receive(:updated?).and_return(true) }

        it 'includes the lead paragraph for updates' do
          expect(body).to include('We=E2=80=99ve updated your appointment')
        end

        it 'identifies the message correctly' do
          expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"appointment_modified"')
        end
      end
    end
  end
end
