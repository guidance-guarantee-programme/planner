require 'rails_helper'

RSpec.describe 'GET /locations/{location_id}/guiders' do
  scenario 'Returns a list of active guiders' do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_they_request_the_guiders
      then_the_correct_guiders_are_returned
    end
  end

  scenario 'Returns the child guiders' do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_they_request_the_child_location_guiders
      then_the_correct_child_location_guiders_are_returned
    end
  end

  scenario 'Returns the parent guiders for a location with no guiders' do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_they_request_the_child_location_with_no_guiders
      then_the_correct_guiders_are_returned
    end
  end

  def when_they_request_the_child_location_guiders
    dalston_location_id = '183080c6-642b-4b8f-96fd-891f5cd9f9c7'

    get guiders_path(location_id: dalston_location_id), as: :json
  end

  def when_they_request_the_child_location_with_no_guiders
    haringey_location_id = 'c165d25e-f27b-4ce9-b3d3-e7415ebaa93c'

    get guiders_path(location_id: haringey_location_id), as: :json
  end

  def then_the_correct_child_location_guiders_are_returned
    @guiders = JSON.parse(response.body)

    expect(@guiders).to eq([{ 'id' => 67, 'title' => 'B Childs' }])
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
