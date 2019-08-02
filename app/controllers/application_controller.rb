class ApplicationController < ActionController::Base
  include Pollable
  include BookingLocationable

  protect_from_forgery with: :exception

  add_flash_types :success, :warning

  include GDS::SSO::ControllerMethods
  include LogrageFilterer

  before_action do
    authorise_user!(User::BOOKING_MANAGER_PERMISSION)
  end
end
