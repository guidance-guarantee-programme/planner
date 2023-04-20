class UsersController < ApplicationController
  before_action do
    authorise_user!(any_of: [User::ADMINISTRATOR_PERMISSION, User::ORG_ADMIN_PERMISSION])
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
