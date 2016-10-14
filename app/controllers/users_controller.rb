class UsersController < ApplicationController
  before_action do
    authorise_user!(User::ADMINISTRATOR_PERMISSION)
  end

  def update
    current_user.update!(user_params)
    redirect_back fallback_location: booking_requests_path
  end

  private

  def user_params
    params.require(:user).permit(:organisation_content_id)
  end
end
