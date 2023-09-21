class PrintedThirdPartyConsentFormPresenter
  def initialize(appointment)
    @appointment = appointment
  end

  def to_h # rubocop:disable Metrics/MethodLength
    booking_request = appointment.booking_request

    {
      reference: appointment.reference,
      third_party_name: appointment.name,
      address_line_1: booking_request.data_subject_name,
      address_line_2: booking_request.consent_address_line_one,
      address_line_3: booking_request.consent_address_line_two,
      address_line_4: booking_request.consent_address_line_three,
      address_line_5: booking_request.consent_town,
      address_line_6: booking_request.consent_county,
      address_line_7: booking_request.consent_postcode
    }
  end

  private

  attr_reader :appointment
end
