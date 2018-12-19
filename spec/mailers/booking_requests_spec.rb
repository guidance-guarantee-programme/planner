require 'rails_helper'

RSpec.describe BookingRequests do
  let(:location_id) { '183080c6-642b-4b8f-96fd-891f5cd9f9c7' }
  let(:booking_location_id) { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
  let(:booking_location) { BookingLocations.find(booking_location_id) }
  let(:actual_location) { booking_location.location_for(location_id) }
  let(:booking_request) do
    create(:booking_request, location_id: location_id, booking_location_id: booking_location_id)
  end

  describe 'Customer notification' do
    subject(:mail) { BookingRequests.customer(booking_request, booking_location) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment Request')
      expect(mail.to).to eq([booking_request.email])
      expect(mail.reply_to).to eq(['dave@example.com'])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
      expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"customer_booking_request"')
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the booking request particulars' do
        expect(body).to include(booking_request.name)
        expect(body).to include(booking_request.phone)
        expect(body).to include(booking_request.reference)
        expect(body).to include('s*******p')
      end

      it 'includes the actual location particulars' do
        expect(body).to include(actual_location.name)
        expect(body).to include(actual_location.online_booking_twilio_number)
      end

      it 'includes the three selected slots' do
        expect(body).to include(booking_request.primary_slot.to_s)
        expect(body).to include(booking_request.secondary_slot.to_s)
        expect(body).to include(booking_request.tertiary_slot.to_s)
      end
    end
  end

  describe 'Booking Manager Notification' do
    let(:booking_manager) { build_stubbed(:hackney_booking_manager) }

    subject(:mail) { BookingRequests.booking_manager(booking_request, booking_manager) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Pension Wise Booking Request')
      expect(mail.to).to eq([booking_manager.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
      expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"booking_manager_booking_request"')
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes a link to the booking request page' do
        expect(body).to include("http://localhost:3001/booking_requests/#{booking_request.id}/appointments/new")
      end
    end

    context 'for an appointment' do
      let(:booking_request) { create(:appointment) }

      it 'renders the appointment particulars' do
        expect(mail.subject).to eq('Pension Wise Appointment')

        expect(subject.body.encoded).to include("/appointments/#{booking_request.id}/edit")
      end
    end
  end

  describe 'Email failure notification' do
    let(:booking_request) { build_stubbed(:hackney_booking_request) }
    let(:booking_manager) { build_stubbed(:hackney_booking_manager) }

    subject(:mail) { BookingRequests.email_failure(booking_request, booking_manager) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Email Failure - Pension Wise Booking Request')
      expect(mail.to).to eq([booking_manager.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
      expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"email_failure_booking_request"')
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes a link to the booking request' do
        expect(body).to include("http://localhost:3001/booking_requests/#{booking_request.id}/appointments/new")
      end

      context 'when the email fails after the appointment is created' do
        let(:appointment) { build_stubbed(:appointment) }
        let(:booking_request) { appointment.booking_request }

        it 'includes a link to the booking request' do
          expect(body).to include("http://localhost:3001/appointments/#{appointment.id}/edit")
        end
      end
    end
  end
end
