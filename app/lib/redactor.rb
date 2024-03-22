class Redactor
  def initialize(reference)
    @reference = reference
  end

  def call
    return unless booking_request = BookingRequest.find(reference)

    ActiveRecord::Base.transaction do
      redact_booking_request(booking_request)
      redact_appointment(booking_request.appointment)
    end
  end

  def self.redact_for_gdpr
    BookingRequest.for_redaction.pluck(:id).each do |reference|
      new(reference).call
    end
  end

  private

  def redact_booking_request(booking_request)
    booking_request.assign_attributes(booking_attributes)

    booking_request.power_of_attorney_evidence.purge
    booking_request.data_subject_consent_evidence.purge
    booking_request.save(validate: false)
    booking_request.activities.where(type: 'AuditActivity').delete_all
  end

  def redact_appointment(appointment)
    return unless appointment

    appointment.without_auditing do
      appointment.assign_attributes(appointment_attributes)
      appointment.save(validate: false)
      appointment.generated_consent_form.purge
      appointment.own_and_associated_audits.delete_all
    end
  end

  def appointment_attributes # rubocop:disable Metrics/MethodLength
    booking_attributes.except(
      :address_line_one,
      :address_line_two,
      :address_line_three,
      :town,
      :county,
      :postcode,
      :gdpr_consent,
      :email_consent,
      :data_subject_name,
      :data_subject_date_of_birth,
      :consent_address_line_one,
      :consent_address_line_two,
      :consent_address_line_three,
      :consent_town,
      :consent_county,
      :consent_postcode
    )
  end

  def booking_attributes # rubocop:disable Metrics/MethodLength
    {
      name: 'redacted',
      email: 'redacted@example.com',
      email_consent: 'redacted@example.com',
      data_subject_name: 'redact',
      data_subject_date_of_birth: '1950-01-01',
      phone: '000000000',
      memorable_word: 'redacted',
      date_of_birth: '1950-01-01',
      additional_info: 'redacted',
      address_line_one: 'redacted',
      address_line_two: 'redacted',
      address_line_three: 'redacted',
      town: 'redacted',
      county: 'redacted',
      postcode: 'redacted',
      consent_address_line_one: 'redacted',
      consent_address_line_two: 'redacted',
      consent_address_line_three: 'redacted',
      consent_town: 'redacted',
      consent_county: 'redacted',
      consent_postcode: 'redacted',
      gdpr_consent: 'no'
    }
  end

  attr_reader :reference
end
