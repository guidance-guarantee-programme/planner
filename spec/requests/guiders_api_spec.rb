require 'rails_helper'

RSpec.describe 'GET /locations/{location_id}/guiders' do
  scenario 'Returns a list of active guiders' do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_they_request_the_guiders
      then_the_correct_guiders_are_returned
    end
  end

  def when_they_request_the_guiders
    hackney_location_id = 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef'

    get guiders_path(location_id: hackney_location_id), as: :json
  end

  def then_the_correct_guiders_are_returned
    expect(response).to be_ok

    @guiders = JSON.parse(response.body)
    expect(@guiders).to eq(
      [
        { 'id' => 1, 'title' => 'B Lovell' },
        { 'id' => 2, 'title' => 'J Smith' },
        { 'id' => 3, 'title' => 'B Johnson' },
        { 'id' => 4, 'title' => 'J Jones' }
      ]
    )
  end
end
