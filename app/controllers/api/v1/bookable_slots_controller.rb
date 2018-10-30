module Api
  module V1
    class BookableSlotsController < ActionController::Base
      def index
        render json: slots
      end

      private

      def slots
        schedule = Schedule.current(params[:location_id])
        scope    = schedule.bookable_slots_in_window

        return scope if schedule.default?

        scope.group_by(&:start_at).values.map(&:first)
      end
    end
  end
end
