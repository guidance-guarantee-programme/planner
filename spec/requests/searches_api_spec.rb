require 'rails_helper'

RSpec.describe 'GET /api/v1/searches' do
  scenario 'searching for appointments' do
    given_the_user_identifies_as(:pension_wise_api_user) do
      and_an_appointment_matching_the_search_criteria_exists
      when_a_valid_search_is_made
      then_the_service_responds_ok
      and_the_results_are_serialized_as_json
    end
  end

  scenario 'unauthorized access' do
    given_the_user_identifies_as(:user) do
      when_an_unauthorized_request_is_made
      then_the_service_responds_with_a_403_status
    end
  end

  def given_the_client_identifies_as_pension_wise_api
    create(:pension_wise_api_user)
  end

  def when_a_valid_search_is_made
    get api_v1_searches_path, params: { query: 'ben@example.com' }, as: :json
  end

  def and_an_appointment_matching_the_search_criteria_exists
    @appointment = create(:appointment, email: 'ben@example.com')
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_the_results_are_serialized_as_json
    results = JSON.parse(response.body)

    expect(results.first).to eq(
      'reference' => @appointment.reference,
      'name' => @appointment.name,
      'url' => "http://localhost:3001/appointments/#{@appointment.id}/edit",
      'application' => 'Planner'
    )
  end

  def given_an_unpermitted_gds_sso_user
    create(:user)
  end

  def when_an_unauthorized_request_is_made
    get api_v1_searches_path
  end

  def then_the_service_responds_with_a_403_status
    expect(response).to be_forbidden
  end
end
