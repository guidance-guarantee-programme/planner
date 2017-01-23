require 'rails_helper'

RSpec.describe 'Sidekiq control panel' do
  scenario 'requires authentication' do
    with_real_sso do
      they_are_required_to_authenticate
    end
  end

  scenario 'successfully authenticating' do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_they_visit_the_sidekiq_panel
      then_they_are_authenticated
    end
  end

  def when_they_visit_the_sidekiq_panel
    get '/sidekiq'
  end

  def they_are_required_to_authenticate
    expect { get '/sidekiq' }.to raise_error(ActionController::RoutingError)
  end

  def then_they_are_authenticated
    expect(response).to be_ok
  end
end
