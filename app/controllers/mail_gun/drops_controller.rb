module MailGun
  class DropsController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def create
      form = DropForm.new(drop_params)
      form.create_activity

      head :ok
    end

    private

    def drop_params # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      event_data = params['event-data']

      description = event_data['delivery-status'][:description].presence ||
                    event_data['delivery-status'][:message].presence

      {
        event: event_data[:event],
        recipient: event_data[:recipient],
        description: description,
        message_type: event_data['user-variables'][:message_type],
        environment: event_data['user-variables'][:environment],
        online_booking: event_data['user-variables'][:online_booking],
        timestamp: params[:signature][:timestamp],
        token: params[:signature][:token],
        signature: params[:signature][:signature]
      }
    end
  end
end
