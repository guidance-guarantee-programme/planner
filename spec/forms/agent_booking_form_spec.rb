require 'rails_helper'

RSpec.describe AgentBookingForm do
  subject do
    described_class.new(
      location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      booking_location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      name: 'Rick James',
      email: 'rick@example.com',
      phone: '0208 252 4777',
      date_of_birth: '01/01/1950',
      defined_contribution_pot_confirmed: true,
      memorable_word: 'couch',
      first_choice_slot: '2017-01-01 13:00',
      terms_and_conditions: '1',
      address_line_one: '1 Main Street',
      town: 'London',
      county: 'London',
      postcode: 'W1 1AA',
      country: 'United Kingdom',
      where_you_heard: 1
    )
  end

  describe 'validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    context 'when an email is not provided' do
      it 'requires an address' do
        subject.email = ''
        subject.address_line_one = ''

        expect(subject).to be_invalid
      end

      it 'is valid when an address is supplied instead' do
        subject.email = ''

        expect(subject).to be_valid
      end
    end
  end
end
