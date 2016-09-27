require 'openssl'

TokenVerificationFailure = Class.new(StandardError)

class DropForm
  include ActiveModel::Model

  attr_accessor :event
  attr_accessor :recipient
  attr_accessor :description
  attr_accessor :message_type
  attr_accessor :environment
  attr_accessor :online_booking
  attr_accessor :timestamp
  attr_accessor :token
  attr_accessor :signature

  validates :timestamp, presence: true
  validates :token, presence: true
  validates :signature, presence: true
  validates :booking_request, presence: true
  validates :environment, inclusion: { in: %w(production) }
  validates :online_booking, inclusion: { in: %w(True) }

  def create_activity
    return unless valid?

    verify_token!

    DropActivity.from(
      message_type,
      description,
      booking_request
    )
  end

  private

  def booking_request
    BookingRequest.latest(recipient)
  end

  # rubocop:disable Style/GuardClause
  def verify_token!
    digest = OpenSSL::Digest::SHA256.new
    data   = timestamp + token

    unless signature == OpenSSL::HMAC.hexdigest(digest, api_token, data)
      raise TokenVerificationFailure
    end
  end

  def api_token
    ENV['MAILGUN_API_TOKEN']
  end
end
