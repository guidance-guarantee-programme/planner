module Api
  module V1
    class BookingRequestsController < ActionController::Base
      include GDS::SSO::ControllerMethods

      before_action :authorise_api_user!

      def create
      end

      private

      def authorise_api_user!
        authorise_user!(User::PENSION_WISE_API_PERMISSION)
      end
    end
  end
end
