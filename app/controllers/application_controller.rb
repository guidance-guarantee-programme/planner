class ApplicationController < ActionController::Base
  include Pollable

  protect_from_forgery with: :exception

  add_flash_types :success, :warning

  include GDS::SSO::ControllerMethods
  include LogrageFilterer

  before_action do
    authorise_user!(User::BOOKING_MANAGER_PERMISSION)
  end

  def booking_location
    @booking_location ||= BookingLocationDecorator.new(
      BookingLocations.find(current_user.booking_location_id)
    )
  end
  helper_method :booking_location
end
