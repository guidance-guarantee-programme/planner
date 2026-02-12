class SmsCancellationSuccessJob < NotifyJobBase
  TEMPLATE_ID = '1cbd533d-4cae-40a6-a2b5-339af96b3c58'.freeze
  VIDEO_TEMPLATE_ID = '03a13cd2-fa45-40ad-8faf-3e119f482f65'.freeze

  def perform(appointment)
    return unless api_key

    appointment = LocationAwareEntity.new(
      entity: appointment,
      booking_location: BookingLocations.find(appointment.location_id)
    )

    send_sms(appointment)
  end

  private

  def send_sms(appointment)
    client.send_sms(
      phone_number: appointment.phone,
      template_id: appointment.video_appointment? ? VIDEO_TEMPLATE_ID : TEMPLATE_ID,
      reference: appointment.reference,
      personalisation: {
        date: appointment.proceeded_at.to_s(:govuk_date_short),
        location: appointment.location_name
      }
    )
  end
end
