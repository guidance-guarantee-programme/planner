module Agent
  class ApplicationController < ActionController::Base
    include Pollable
    include LogrageFilterer
    include BookingLocationable
    include GDS::SSO::ControllerMethods

    layout 'application'
    protect_from_forgery with: :exception
    add_flash_types :success, :warning

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
      super(location_id: location_id)
    end
  end
end
