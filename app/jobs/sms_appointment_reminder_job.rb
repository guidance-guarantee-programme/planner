class SmsAppointmentReminderJob < SmsJobBase
  TEMPLATE_ID = '443d8862-3c3c-438d-8fe6-6a3e1aa539eb'.freeze

  def perform(appointment)
    return unless api_key

    appointment = LocationAwareEntity.new(
      entity: appointment,
      booking_location: BookingLocations.find(appointment.location_id)
    )

    send_sms_reminder(appointment)

    SmsReminderActivity.from(appointment)
  end

  private

  def send_sms_reminder(appointment)
    sms_client.send_sms(
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
