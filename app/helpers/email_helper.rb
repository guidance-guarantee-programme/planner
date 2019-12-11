module EmailHelper
  def mailgun_validation_config
    {
      'email-validation': 'true',
      api_key: ENV.fetch('MAILGUN_VALIDATION_KEY') { 'pubkey-a7219986d35043ba4f5ad6563ea0628a' }
    }
  end

  def p(&block) # rubocop:disable Metrics/MethodLength
    content_tag(
      :p,
      capture(&block),
      style: [
        'color: #0B0C0C',
        'font-family: Helvetica, Arial, sans-serif',
        'margin: 15px 0',
        'font-size: 16px',
        'line-height: 1.315789474'
      ].join(';')
    )
  end

  def mailer_booking_link(booking_request_or_appointment)
    name = booking_request_or_appointment.model_name.human.downcase
    url  = if booking_request_or_appointment.entity.is_a?(Appointment)
             edit_appointment_url(booking_request_or_appointment)
           else
             new_booking_request_appointment_url(booking_request_or_appointment)
           end

    link_to "View the #{name}", url
  end
end
