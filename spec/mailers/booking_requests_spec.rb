require 'rails_helper'

RSpec.describe BookingRequests do
  describe 'Customer notification' do
    let(:location_id) { '183080c6-642b-4b8f-96fd-891f5cd9f9c7' }
    let(:booking_location_id) { 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef' }
    let(:booking_location) { BookingLocations.find(booking_location_id) }
    let(:booking_request) do
      create(:booking_request, location_id: location_id, booking_location_id: booking_location_id)
    end

    subject(:mail) { BookingRequests.customer(booking_request, booking_location) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Your Pension Wise Appointment Request')
      expect(mail.to).to eq([booking_request.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
      expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"customer_booking_request"')
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes the booking request particulars' do
        expect(body).to include(booking_request.name)
        expect(body).to include(booking_request.phone)
        expect(body).to include(booking_request.reference)
        expect(body).to include(booking_request.memorable_word)
      end

      it 'includes the booking location particulars' do
        expect(body).to include(booking_location.name_for(location_id))
        expect(body).to include(booking_location.online_booking_twilio_number)
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

    subject(:mail) { BookingRequests.booking_manager(booking_manager) }

    it_behaves_like 'mailgun identified email'

    it 'renders the headers' do
      expect(mail.subject).to eq('Pension Wise Booking Request')
      expect(mail.to).to eq([booking_manager.email])
      expect(mail.from).to eq(['appointments@pensionwise.gov.uk'])
      expect(mail['X-Mailgun-Variables'].value).to include('"message_type":"booking_manager_booking_request"')
    end

    describe 'rendering the body' do
      let(:body) { subject.body.encoded }

      it 'includes a link to the service start page' do
        expect(body).to include('http://localhost:3001')
      end
    end
  end
end
