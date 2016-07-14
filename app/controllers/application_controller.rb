class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include GDS::SSO::ControllerMethods

  before_action do
    authorise_user!(User::BOOKING_MANAGER_PERMISSION)
  end
end
