require 'openssl'

TokenVerificationFailure = Class.new(StandardError)

class DropForm
  include ActiveModel::Model

  attr_accessor :event
  attr_accessor :recipient
  attr_accessor :description
  attr_accessor :timestamp
  attr_accessor :token
  attr_accessor :signature

  validates :timestamp, presence: true
  validates :token, presence: true
  validates :signature, presence: true

  def create_activity
    verify_token!

    DropActivity.create(
      booking_request: booking_request,
      message: description
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

    unless valid? && signature == OpenSSL::HMAC.hexdigest(digest, api_token, data)
      raise TokenVerificationFailure
    end
  end

  def api_token
    ENV['MAILGUN_API_TOKEN']
  end
end
