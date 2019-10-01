module Api
  module V1
    class BookingRequestsController < ActionController::Base
      include GDS::SSO::ControllerMethods
      include LogrageFilterer
      include RealtimeProcessable

      skip_before_action :verify_authenticity_token
      before_action :authorise_api_user!

      def create
        booking_request = BookingRequest.new(booking_request_params)

        if booking_request.save
          process_booking_request(booking_request)
          render_response(booking_request)
        else
          render_errors(booking_request)
        end
      end

      def batch_reassign
        BatchBookingRequestReassignment.new(
          booking_location_id: params[:booking_location_id],
          location_id:         params[:location_id]
        ).call

        head :no_content
      end

      private

      def render_response(booking_request)
        if booking_request.appointment
          appointment = location_aware_appointment(booking_request.appointment)

          render json: appointment, serializer: AppointmentConfirmationSerializer, status: :created
        else
          render json: {}, status: :created
        end
      end

      def location_aware_appointment(appointment)
        LocationAwareEntity.new(
          entity: appointment,
          booking_location: BookingLocations.find(appointment.location_id)
        )
      end

      def send_notifications(booking_request)
        CustomerConfirmationJob.perform_later(booking_request)
        BookingManagerConfirmationJob.perform_later(booking_request)
        SlackPingerJob.perform_later(booking_request)
      end

      def render_errors(booking_request)
        render json: { errors: booking_request.errors }, status: :unprocessable_entity
      end

      def booking_request_params # rubocop:disable Metrics/MethodLength
        params.require(:booking_request).permit(
          :booking_location_id,
          :location_id,
          :name,
          :email,
          :phone,
          :memorable_word,
          :age_range,
          :date_of_birth,
          :accessibility_requirements,
          :defined_contribution_pot_confirmed,
          :additional_info,
          :placed_by_agent,
          :where_you_heard,
          :gdpr_consent,
          :pension_provider,
          slots: %i(date from to priority)
        ).tap { |p| p[:slots_attributes] = p.delete(:slots) }
      end

      def authorise_api_user!
        authorise_user!(User::PENSION_WISE_API_PERMISSION)
      end
    end
  end
end
