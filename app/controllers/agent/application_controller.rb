module Agent
  class ApplicationController < ActionController::Base
    include GDS::SSO::ControllerMethods
    include LogrageFilterer

    layout 'application'
    protect_from_forgery with: :exception

    before_action { authorise_user!(User::AGENT_PERMISSION) }

    protected

    def location_id
      params[:location_id]
    end
    helper_method :location_id

    def location
      @location ||= booking_location.location_for(location_id)
    end
    helper_method :location

    def booking_location_id
      booking_location.id
    end

    def booking_location
      @booking_location ||= BookingLocationDecorator.new(
        BookingLocations.find(location_id)
      )
    end
  end
end
