require 'rails_helper'

RSpec.describe Redactor do
  describe '.redact_for_gdpr' do
    it 'redacts records yet to be redacted, greater than 2 years old' do
      travel_to '2018-02-28 10:00' do
        @redacted = create(:hackney_booking_request, name: 'redacted')
        @included = create(:hackney_booking_request)
      end

      travel_to '2020-01-01 10:00' do
        @excluded = create(:hackney_booking_request)
      end

      travel_to '2020-03-31 10:00' do
        described_class.redact_for_gdpr
      end

      # was redacted
      expect(@included.reload.created_at).not_to eq(@included.updated_at)
      # was already redacted so not updated
      expect(@redacted.reload.created_at).to eq(@redacted.updated_at)
      # was outside the date range so not updated
      expect(@excluded.reload.created_at).to eq(@excluded.updated_at)
    end
  end

  describe '#call' do
    it 'redacts all personally identifying information' do
      appointment = create(:appointment)
      redactor    = described_class.new(appointment.reference)

      redactor.call

      expect(appointment.booking_request.reload).to have_attributes(
        name: 'Redacted',
        email: 'redacted@example.com',
        phone: '000000000',
        memorable_word: 'redacted',
        date_of_birth: '1950-01-01'.to_date,
        additional_info: 'redacted',
        address_line_one: 'redacted',
        address_line_two: 'redacted',
        address_line_three: 'redacted',
        town: 'redacted',
        county: 'redacted',
        postcode: 'redacted',
        gdpr_consent: 'no'
      )

      expect(appointment.booking_request.activities.where(type: 'AuditActivity')).to be_empty

      expect(appointment.reload).to have_attributes(
        name: 'redacted',
        email: 'redacted@example.com',
        phone: '000000000',
        memorable_word: 'redacted',
        date_of_birth: '1950-01-01'.to_date,
        additional_info: 'redacted'
      )

      expect(appointment.own_and_associated_audits).to be_empty
    end
  end
end
