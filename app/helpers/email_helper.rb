module EmailHelper
  def p(&block) # rubocop:disable Metrics/MethodLength
    content_tag(
      :p,
      capture(&block),
      style: [
        'color: #000B3B',
        'font-family: Calibri, Arial, sans-serif',
        'margin: 15px 0',
        'font-size: 16px',
        'line-height: 1.315789474'
      ].join(';')
    )
  end

  def h2(&block) # rubocop:disable MethodLength
    content_tag(
      :h2,
      capture(&block),
      style: [
        'color: #0F19A0 !important',
        'font-family: Calibri, Arial, sans-serif',
        'margin: 15px 0',
        'font-weight: 700',
        'font-size: 18px',
        'line-height: 1.111111111',
        'padding: 15px 0'
      ].join(';')
    )
  end

  def ul(&block) # rubocop:disable MethodLength
    content_tag(
      :ul,
      capture(&block),
      style: [
        'color: #0B0C0C',
        'font-family: Calibri, Arial, sans-serif',
        'margin-top: 15px',
        'margin-bottom: 15px',
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
