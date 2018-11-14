module Api
  module V1
    class BookableSlotsController < ActionController::Base
      def index
        render json: slots
      end

      private

      def slots
        schedule = Schedule.current(params[:location_id])

        schedule.without_appointments.group_by(&:start_at).values.map(&:first)
      end
    end
  end
end
