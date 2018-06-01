class SmsCancellationSuccessJob < SmsJobBase
  TEMPLATE_ID = '1cbd533d-4cae-40a6-a2b5-339af96b3c58'.freeze

  def perform(appointment)
    return unless api_key

    sms_client.send_sms(
      phone_number: appointment.phone,
      template_id: TEMPLATE_ID,
      reference: appointment.reference
    )
  end
end
