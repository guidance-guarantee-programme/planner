class SmsCancellationsController < ActionController::Base
  wrap_parameters false

  skip_before_action :verify_authenticity_token
  before_action :token_authenticate

  def create
    SmsCancellation.new(callback_params).call

    head :no_content
  end

  private

  def callback_params
    params.permit(:source_number, :message)
  end

  def token_authenticate
    authenticate_or_request_with_http_token do |token|
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(token),
        ::Digest::SHA256.hexdigest(notify_callback_bearer_token)
      )
    end
  end

  def notify_callback_bearer_token
    ENV.fetch('NOTIFY_CALLBACK_BEARER_TOKEN')
  end

  def append_info_to_payload(payload)
    super
    payload[:params] = request.filtered_parameters
  end
end
