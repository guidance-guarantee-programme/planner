require 'notifications/client'

class PrintedConfirmationLetterJob < ActiveJob::Base
  TEMPLATE_ID = '8c5c2143-f904-4b83-8c71-6c4063cba27d'.freeze

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
      template_id: TEMPLATE_ID,
      reference: appointment.reference,
      personalisation: appointment.to_h
    )

    PrintedConfirmationActivity.from(appointment)
  end

  private

  def notify_client
    @notify_client ||= Notifications::Client.new(api_key)
  end

  def api_key
    ENV['NOTIFY_API_KEY']
  end
end
