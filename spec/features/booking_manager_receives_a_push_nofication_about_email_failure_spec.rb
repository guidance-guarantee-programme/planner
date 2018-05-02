require 'rails_helper'

RSpec.feature 'Booking manager receives a push notification about email failure' do
  scenario 'When viewing booking requests', js: true do
    given_the_user_identifies_as_hackneys_booking_manager do
      when_the_booking_manager_views_the_booking_requests
      then_they_are_connected_via_websocket
      when_an_email_failure_occurs
      then_a_growl_notification_appears
    end
  end

  def when_the_booking_manager_views_the_booking_requests
    @page = Pages::BookingRequests.new
    @page.load
  end

  def then_they_are_connected_via_websocket
    expect(connect).to eq('connected')
  end

  def when_an_email_failure_occurs
    booking_request = create(:hackney_booking_request)
    PusherDropNotificationJob.perform_now(booking_request)
  end

  def then_a_growl_notification_appears
    expect(@page.growls.first.title).to have_text('Email failure')
    expect(@page.growls.first.message).to have_text('The email to morty@example.com failed to send')
  end
end
