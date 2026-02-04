require 'rails_helper'

RSpec.describe Appointments do
  let(:appointment) do
    build_stubbed(:appointment, location_id: '183080c6-642b-4b8f-96fd-891f5cd9f9c7')
  end
  let(:hackney) { BookingLocations.find('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef') }

  describe 'BSL customer exit poll' do
    let(:appointment) { build_stubbed(:appointment, :bsl, status: :completed) }

    subject(:mail) { described_class.bsl_customer_exit_poll(appointment, hackney) }

    it_behaves_like 'mailgun identified email'

    it 'includes the feedback link' do
      expect(subject.body.encoded).to include('www.pensionwise.gov.uk/bsl-exit-poll')
    end
  end

  describe 'Missed appointment' do
    subject(:mail) { described_class.missed(appointment) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['appointments.pensionwise@moneyhelper.org.uk'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include(appointment.reference)
        expect(body).to include('missed your Pension Wise  appointment')
      end
    end
  end

  describe 'Appointment changed' do
    let(:appointment) { create(:appointment, proceeded_at: 3.weeks.from_now) }
    let(:booking_manager) { create(:hackney_booking_manager) }

    before { appointment.update(name: 'Bob Jones', email: 'bob@bob.com') }

    subject(:mail) { described_class.booking_manager_appointment_changed(appointment, booking_manager.email) }

    it_behaves_like 'mailgun identified email'

    context 'when it is a regular update' do
      it 'subject includes `changed`' do
        expect(mail.subject).to eq('Pension Wise Appointment Changed')
      end
    end

    context 'when it is a cancellation' do
      it 'subject includes `cancelled`' do
        appointment.current_user = build(:agent)
        # cancelled prior to appointment
        appointment.update(
          status: :cancelled_by_customer,
          secondary_status: Appointment::AGENT_PERMITTED_SECONDARY
        )

        expect(mail.subject).to eq('Pension Wise Appointment Cancelled')
      end
    end

    it 'renders the headers' do
      expect(mail.to).to eq([booking_manager.email])
      expect(mail.from).to eq(['appointments.pensionwise@moneyhelper.org.uk'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include(appointment.reference)
        expect(body).to include('<li>name</li>', '<li>email</li>')
      end
    end
  end

  describe 'Cancellation' do
    before do
      allow(appointment).to receive(:newly_cancelled?).and_return(true)
    end

    subject(:mail) { described_class.cancellation(appointment) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment Cancellation')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['appointments.pensionwise@moneyhelper.org.uk'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include(appointment.reference)
        expect(body).to include('cancelled')

        expect(body).not_to include('book a phone appointment')
      end
    end
  end

  describe 'SMS cancellation' do
    let(:booking_manager) { create(:hackney_booking_manager) }

    subject(:mail) { described_class.booking_manager_cancellation(booking_manager.email, appointment) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Pension Wise Appointment SMS Cancellation')
      expect(mail.to).to eq([booking_manager.email])
      expect(mail.from).to eq(['appointments.pensionwise@moneyhelper.org.uk'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include(appointment.reference)
        expect(body).to include("/appointments/#{appointment.id}/edit")
        expect(body).to include('Ben Lovell') # guider
      end
    end
  end

  describe 'Customer reminder' do
    subject(:mail) { described_class.reminder(appointment, hackney) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment Reminder')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['appointments.pensionwise@moneyhelper.org.uk'])
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
        expect(body).to include('22 Dalston Lane, Hackney, London, E8 3AZ')
      end
    end
  end

  describe 'Customer video appointment' do
    let(:appointment) { create(:appointment, :video) }
    subject(:mail) { described_class.customer_video_appointment(appointment, hackney) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Video Appointment Link')
      expect(mail.to).to eq([appointment.email])
      expect(mail.from).to eq(['appointments.pensionwise@moneyhelper.org.uk'])
      expect(mail.reply_to).to eq(['dave@example.com'])
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the appointment particulars' do
        expect(body).to include(appointment.video_appointment_url)
      end
    end
  end

  describe 'Customer notification' do
    subject(:mail) { described_class.customer(appointment, hackney) }

    it_behaves_like 'mailgun identified email'

    context 'when a video appointment' do
      let(:appointment) { create(:appointment, :video) }

      it 'renders the headers' do
        expect(mail.subject).to eq('Your Pension Wise Video Appointment')
      end

      describe 'rendering the body' do
        let(:body) { subject.body.encoded }

        it 'includes video specifics' do
          expect(body).to include('Your Pension Wise video  appointment is')
        end

        it 'includes the appointment particulars' do
          expect(body).not_to include('Dalston')
        end

        it 'includes the guider first name' do
          expect(body).to include('Ben')
        end

        it 'does not include the address' do
          expect(body).not_to include('22 Dalston Lane, Hackney, London, E8 3AZ')
        end
      end
    end

    context 'when a regular appointment' do
      it 'renders the headers' do
        expect(mail.subject).to eq('Your Pension Wise Appointment')
        expect(mail.to).to eq([appointment.email])
        expect(mail.from).to eq(['appointments.pensionwise@moneyhelper.org.uk'])
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
          expect(body).to include('22 Dalston Lane, Hackney, London, E8 3AZ')
        end

        context 'when sending the initial appointment notification' do
          it 'identifies the message correctly' do
            expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"appointment_confirmation"')
          end
        end

        context 'when sending the updated appointment notification' do
          before { allow(appointment).to receive(:updated?).and_return(true) }

          it 'includes the lead paragraph for updates' do
            expect(body).to include('Your Pension Wise  appointment has been updated')
          end

          it 'identifies the message correctly' do
            expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"appointment_modified"')
          end
        end
      end
    end
  end
end
