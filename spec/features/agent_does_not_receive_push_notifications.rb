require 'rails_helper'

RSpec.feature 'Agent does not receive push notifications' do
  scenario 'When placing a booking request', js: true do
    given_the_user_identifies_as_an_agent do
      when_they_are_placing_a_booking_request
      then_they_are_not_connected_via_websocket
    end
  end

  def when_they_are_placing_a_booking_request
    @page = Pages::AgentBooking.new
    @page.load(location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
  end

  def then_they_are_not_connected_via_websocket
    expect(page.evaluate_script('Pusher.instance')).to be_nil
  end
end
