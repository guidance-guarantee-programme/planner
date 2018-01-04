class HomeController < ActionController::Base
  include GDS::SSO::ControllerMethods
  include LogrageFilterer

  skip_before_action

  before_action do
    authorise_user!(
      any_of: [User::BOOKING_MANAGER_PERMISSION, User::AGENT_MANAGER_PERMISSION]
    )
  end

  def index
    if agent_manager_only?
      redirect_to agent_search_index_path
    else
      redirect_to booking_requests_path
    end
  end

  private

  def agent_manager_only?
    current_user.agent_manager? && !current_user.booking_manager?
  end
end
