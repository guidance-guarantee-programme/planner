module Api
  module V2
    class BookableSlotsController < ActionController::Base
      def index
        render json: slots
      end

      private

      def slots
        Schedule.current(params[:location_id]).grouped_slots
      end
    end
  end
end
