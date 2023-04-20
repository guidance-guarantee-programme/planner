module Admin
  class SearchesController < ApplicationController
    NON_CITA_EW_BOOKING_LOCATION_IDS = %w(
      0c686436-de02-4d92-8dc7-26c97bb7c5bb
      d0cd2b5a-27dc-4d1d-8d3b-d7b93b5afd4a
    ).freeze

    before_action { authorise_user!(any_of: [User::ADMINISTRATOR_PERMISSION, User::ORG_ADMIN_PERMISSION]) }

    def show
      if @appointment = find_appointment
        assign!(@appointment)

        redirect_to edit_appointment_path(@appointment)
      else
        redirect_back warning: "The appointment '#{params[:id]}' could not be found.", fallback_location: root_path
      end
    end

    private

    def find_appointment
      appointment_scope = Appointment

      if current_user.org_admin?
        appointment_scope = appointment_scope
                            .joins(:booking_request)
                            .where.not(booking_requests: { booking_location_id: NON_CITA_EW_BOOKING_LOCATION_IDS })
      end

      appointment_scope.find_by(booking_request_id: params[:id])
    end

    def assign!(appointment)
      current_user.update!(
        organisation_content_id: appointment.booking_location_id
      )
    end
  end
end
