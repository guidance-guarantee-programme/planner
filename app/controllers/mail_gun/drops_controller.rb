module MailGun
  class DropsController < ActionController::Base
    def create
      form = DropForm.new(drop_params)
      form.create_activity

      head :created
    end

    private

    def drop_params
      params.permit(
        :event,
        :recipient,
        :description,
        :timestamp,
        :token,
        :signature
      )
    end
  end
end
