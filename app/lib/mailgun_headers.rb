module MailgunHeaders
  def mailgun_headers(message_type)
    headers['X-Mailgun-Variables'] = headers_hash(message_type)
  end

  private

  def headers_hash(message_type)
    {
      online_booking: true,
      message_type: message_type,
      environment: Rails.env
    }.to_json
  end
end
