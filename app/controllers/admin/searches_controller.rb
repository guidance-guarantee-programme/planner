module Admin
  class SearchesController < ApplicationController
    before_action { authorise_user!(User::ADMINISTRATOR_PERMISSION) }

    def show
      if @appointment = Appointment.find_by(booking_request_id: params[:id])
        assign!(@appointment)

        redirect_to edit_appointment_path(@appointment)
      else
        redirect_back warning: "The appointment '#{params[:id]}' could not be found.", fallback_location: root_path
      end
    end

    private

    def assign!(appointment)
      current_user.update!(
        organisation_content_id: appointment.booking_location_id
      )
    end
  end
end
