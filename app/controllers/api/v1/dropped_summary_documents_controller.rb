module Api
  module V1
    class DroppedSummaryDocumentsController < ActionController::Base # rubocop:disable Rails/ApplicationController
      include GDS::SSO::ControllerMethods
      include LogrageFilterer

      skip_before_action :verify_authenticity_token
      before_action :authorise_api_user!

      def create
        @booking_request = BookingRequest.find(params[:booking_request_id])

        DroppedSummaryDocumentActivity.create!(
          booking_request: @booking_request,
          message: 'FAIL'
        )

        head :created
      end

      private

      def authorise_api_user!
        authorise_user!(User::PENSION_WISE_API_PERMISSION)
      end
    end
  end
end
