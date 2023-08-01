class PrintedThirdPartyConsentFormJob < NotifyJobBase
  TEMPLATE_ID = '3377953a-69d1-4ef6-aa6a-e20fc9b8fa22'.freeze

  def perform(appointment)
    return unless api_key && appointment.booking_request.printed_consent_form_required?

    booking_request = appointment.booking_request
    personalisation = PrintedThirdPartyConsentFormPresenter.new(appointment).to_h

    client.send_letter(
      template_id: TEMPLATE_ID,
      reference: appointment.reference,
      personalisation: personalisation
    )

    PrintedThirdPartyConsentFormActivity.from!(booking_request)
  end
end
