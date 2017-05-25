require 'rails_helper'

RSpec.describe 'GET /api/v1/locations/{location_id}/bookable_slots' do
  scenario 'returns default availability' do
    when_a_request_is_made
    then_the_service_responds_ok
    and_slots_are_serialized_as_json
  end

  def when_a_request_is_made
    get api_v1_bookable_slots_path(location_id: 'deadbeef'), as: :json
  end

  def then_the_service_responds_ok
    expect(response).to be_ok
  end

  def and_slots_are_serialized_as_json
    JSON.parse(response.body).tap do |json|
      expect(json.first.keys).to match_array(%w(date start end))
    end
  end
end
