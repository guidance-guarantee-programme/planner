class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include GDS::SSO::ControllerMethods

  before_action do
    authorise_user!(User::BOOKING_MANAGER_PERMISSION)
  end

  protected

  def booking_location
    @booking_location ||= BookingLocations.find(current_user.booking_location_id)
  end
end
