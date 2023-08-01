class SmsCancellationSuccessJob < NotifyJobBase
  TEMPLATE_ID = '1cbd533d-4cae-40a6-a2b5-339af96b3c58'.freeze

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
      template_id: TEMPLATE_ID,
      reference: appointment.reference,
      personalisation: {
        date: appointment.proceeded_at.to_s(:govuk_date_short),
        location: appointment.location_name
      }
    )
  end
end
