require 'rails_helper'

RSpec.describe 'POST /api/v1/booking_requests' do
  scenario 'unauthorized access' do
    given_an_unpermitted_gds_sso_user
    when_an_unauthorized_request_is_made
    then_the_service_responds_with_a_403_status
  end

  def given_an_unpermitted_gds_sso_user
    GDS::SSO.test_user = User.new
  end

  def when_an_unauthorized_request_is_made
    post api_v1_booking_requests_path
  end

  def then_the_service_responds_with_a_403_status
    expect(response).to be_forbidden
  end
end
