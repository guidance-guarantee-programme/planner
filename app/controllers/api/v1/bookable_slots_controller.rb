module Api
  module V1
    class BookableSlotsController < ActionController::Base
      def index
        render json: DefaultBookableSlots.new.call
      end
    end
  end
end
