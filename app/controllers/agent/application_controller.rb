module Agent
  class ApplicationController < ActionController::Base
    include GDS::SSO::ControllerMethods
    include LogrageFilterer
    include Pollable

    layout 'application'
    protect_from_forgery with: :exception
    add_flash_types :success, :warning

    before_action do
      authorise_user!(any_of: [User::AGENT_PERMISSION, User::AGENT_MANAGER_PERMISSION])
    end

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
