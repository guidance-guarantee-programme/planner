class SmsCancellationFailureJob < SmsJobBase
  TEMPLATE_ID = 'b0ede1e7-3855-44c6-b0d3-e2521ca3b550'.freeze

  def perform(mobile_number)
    return unless api_key

    sms_client.send_sms(
      phone_number: mobile_number,
      template_id: TEMPLATE_ID,
      reference: mobile_number
    )
  end
end
