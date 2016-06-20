module Api
  module V1
    class BookingRequestsController < ActionController::Base
      include GDS::SSO::ControllerMethods

      before_action :require_signin_permission!

      def create
      end
    end
  end
end
