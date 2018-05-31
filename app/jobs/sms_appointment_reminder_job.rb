require 'notifications/client'

class SmsAppointmentReminderJob < ActiveJob::Base
  TEMPLATE_ID = '443d8862-3c3c-438d-8fe6-6a3e1aa539eb'.freeze

  queue_as :default

  rescue_from(Notifications::Client::RequestError) do |exception|
    Bugsnag.notify(exception)
  end

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
    sms_client = Notifications::Client.new(api_key)

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

  def api_key
    ENV['NOTIFY_API_KEY']
  end
end
