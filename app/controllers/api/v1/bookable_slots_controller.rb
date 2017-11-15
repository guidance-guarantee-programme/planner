module Api
  module V1
    class BookableSlotsController < ActionController::Base
      def index
        render json: slots
      end

      private

      def slots
        schedule = Schedule.current(params[:location_id])
        schedule.bookable_slots_in_window
      end
    end
  end
end
