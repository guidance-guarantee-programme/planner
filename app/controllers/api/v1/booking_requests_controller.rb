module Api
  module V1
    class BookingRequestsController < ActionController::Base
      include GDS::SSO::ControllerMethods

      before_action :authorise_api_user!

      def create
        booking_request = BookingRequest.new(booking_request_params)

        if booking_request.save
          CustomerConfirmationJob.perform_later(booking_request)
          head :created
        else
          render_errors(booking_request)
        end
      end

      private

      def render_errors(booking_request)
        render json: { errors: booking_request.errors }, status: :unprocessable_entity
      end

      def booking_request_params # rubocop:disable Metrics/MethodLength
        params.require(:booking_request).permit(
          :location_id,
          :name,
          :email,
          :phone,
          :memorable_word,
          :age_range,
          :accessibility_requirements,
          :marketing_opt_in,
          :defined_contribution_pot,
          slots: %i(date from to priority)
        ).tap { |p| p[:slots_attributes] = p.delete(:slots) }
      end

      def authorise_api_user!
        authorise_user!(User::PENSION_WISE_API_PERMISSION)
      end
    end
  end
end
