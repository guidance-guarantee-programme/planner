require 'openssl'

TokenVerificationFailure = Class.new(StandardError)

class DropForm
  include ActiveModel::Model

  INTERESTING_MESSAGE_TYPES = %w(
    appointment_modified
    appointment_confirmation
    appointment_reminder
    appointment_cancellation
    customer_booking_request
  ).freeze

  attr_accessor :event, :recipient, :description, :message_type, :environment, :online_booking,
                :timestamp, :token, :signature

  validates :timestamp, presence: true
  validates :token, presence: true
  validates :signature, presence: true
  validates :booking_request, presence: true
  validates :environment, inclusion: { in: %w(production) }
  validates :online_booking, inclusion: { in: [true] }
  validates :message_type, inclusion: { in: INTERESTING_MESSAGE_TYPES }

  def create_activity
    return unless valid?

    verify_token!

    DropActivity.from(
      message_type,
      description,
      booking_request
    )

    EmailDropNotificationJob.perform_later(booking_request)
    PusherDropNotificationJob.perform_later(booking_request)
  end

  private

  def booking_request
    @booking_request ||= BookingRequest.latest(recipient)
  end

  def verify_token!
    digest = OpenSSL::Digest::SHA256.new
    data   = timestamp + token

    raise TokenVerificationFailure unless signature == OpenSSL::HMAC.hexdigest(digest, api_token, data)
  end

  def api_token
    ENV['MAILGUN_API_TOKEN']
  end
end
