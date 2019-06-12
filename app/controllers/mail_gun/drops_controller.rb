module MailGun
  class DropsController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def create
      form = DropForm.new(drop_params)
      form.create_activity

      head :ok
    end

    private

    def drop_params # rubocop:disable Metrics/MethodLength
      params.permit(
        :event,
        :recipient,
        :description,
        :message_type,
        :environment,
        :online_booking,
        :timestamp,
        :token,
        :signature
      )
    end
  end
end
