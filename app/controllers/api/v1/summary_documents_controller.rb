module Api
  module V1
    class SummaryDocumentsController < ActionController::Base # rubocop:disable Rails/ApplicationController
      include GDS::SSO::ControllerMethods
      include LogrageFilterer

      skip_before_action :verify_authenticity_token
      before_action :authorise_api_user!

      def create
        if SummaryDocumentActivity.from(**summary_document_params)
          head :created
        else
          head :unprocessable_entity
        end
      end

      private

      def authorise_api_user!
        authorise_user!(User::PENSION_WISE_API_PERMISSION)
      end

      def summary_document_params
        params
          .permit(:booking_request_id, :owner_uid, :delivery_method)
          .to_h
          .symbolize_keys
      end
    end
  end
end
