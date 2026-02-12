class SmsAppointmentReminderJob < NotifyJobBase
  TEMPLATE_ID = '443d8862-3c3c-438d-8fe6-6a3e1aa539eb'.freeze
  VIDEO_TEMPLATE_ID = 'fc773ec7-de67-4446-940d-ddf151c4715f'.freeze

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
