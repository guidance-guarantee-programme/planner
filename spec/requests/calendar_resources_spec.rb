require 'rails_helper'

RSpec.describe 'GET /calendar_resources.json' do
  scenario 'getting the calendar resources JSON' do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_they_visit_the_calendar_resources_json_feed
      then_the_response_is_ok
      then_they_see_the_guiders_serialized_as_calendar_resources
    end
  end

  def when_they_visit_the_calendar_resources_json_feed
    get calendar_resources_path, as: :json
  end

  def then_the_response_is_ok
    expect(response).to be_ok
  end

  def then_they_see_the_guiders_serialized_as_calendar_resources
    parsed_response = JSON.parse(response.body)

    expect(parsed_response.first).to include(
      'id'    => 1,
      'title' => 'Ben Lovell'
    )
  end
end
