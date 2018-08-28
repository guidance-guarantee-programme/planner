require 'notifications/client'

class PrintedConfirmationLetterJob < ActiveJob::Base
  CONFIRMATION_TEMPLATE_ID = '8c5c2143-f904-4b83-8c71-6c4063cba27d'.freeze
  RESCHEDULE_TEMPLATE_ID   = 'ad01fa1c-1497-4e0b-9e81-8b1a77c763c3'.freeze

  queue_as :default

  rescue_from(Notifications::Client::RequestError) do |exception|
    Bugsnag.notify(exception)
  end

  def perform(appointment)
    return unless api_key
    return unless appointment.postal_confirmation?

    booking_location = BookingLocations.find(appointment.location_id)
    appointment      = PrintedConfirmationPresenter.new(booking_location, appointment)

    notify_client.send_letter(
      template_id: template(appointment),
      reference: appointment.reference,
      personalisation: appointment.to_h
    )

    PrintedConfirmationActivity.from(appointment)
  end

  private

  def template(appointment)
    appointment.updated? ? RESCHEDULE_TEMPLATE_ID : CONFIRMATION_TEMPLATE_ID
  end

  def notify_client
    @notify_client ||= Notifications::Client.new(api_key)
  end

  def api_key
    ENV['NOTIFY_API_KEY']
  end
end
