class PusherDropNotificationJob < ActiveJob::Base
  queue_as :default

  include Rails.application.routes.url_helpers

  def perform(booking_request)
    notify_booking_managers(booking_request)
  end

  private

  def notify_booking_managers(booking_request)
    channel = 'drop_notifications'
    event = booking_request.booking_location_id

    Pusher.trigger(channel, event, payload(booking_request))
  end

  def payload(booking_request)
    {
      title: 'Email failure', fixed: true, delayOnHover: false,
      message: payload_message(booking_request),
      url: payload_url(booking_request)
    }
  end

  def payload_message(booking_request)
    "The email to #{booking_request.email} failed to deliver"
  end

  def payload_url(booking_request)
    if booking_request.appointment
      edit_appointment_path(booking_request.appointment)
    else
      new_booking_request_appointment_path(booking_request)
    end
  end
end
