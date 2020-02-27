module Api
  module V1
    class SearchesController < ActionController::Base
      include GDS::SSO::ControllerMethods
      include LogrageFilterer

      skip_before_action :verify_authenticity_token
      before_action :authorise_api_user!

      def index
        @results = AppointmentSearch.new(params[:query]).call

        render json: @results, each_serializer: AppointmentSearchSerializer
      end

      private

      def authorise_api_user!
        authorise_user!(User::PENSION_WISE_API_PERMISSION)
      end
    end
  end
end
