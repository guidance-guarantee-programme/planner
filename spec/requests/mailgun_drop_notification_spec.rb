require 'rails_helper'

RSpec.describe 'POST /mail_gun/drops' do
  scenario 'inbound hooks create activity entries' do
    perform_enqueued_jobs do
      with_a_configured_token('deadbeef') do
        given_a_hackney_booking_request
        when_mail_gun_posts_a_drop_notification
        then_an_activity_is_created
        and_an_email_is_sent_to_the_booking_manager
        and_a_push_notification_is_sent_to_online_booking_managers
        and_the_service_responds_ok
      end
    end
  end

  before do
    allow(Pusher).to receive(:trigger)
  end

  def with_a_configured_token(token)
    existing = ENV['MAILGUN_API_TOKEN']

    ENV['MAILGUN_API_TOKEN'] = token
    yield
  ensure
    ENV['MAILGUN_API_TOKEN'] = existing
  end

  def given_a_hackney_booking_request
    @booking_manager = create(:hackney_booking_manager)
    @booking_request = create(:hackney_booking_request)
  end

  def when_mail_gun_posts_a_drop_notification
    payload = {
      "signature": {
        "token": 'secret',
        "timestamp": '1474638633',
        "signature": 'abf02bef01e803bea52213cb092a31dc2174f63bcc2382ba25732f4c84e084c1'
      },
      "event-data": {
        "event": 'dropped',
        "delivery-status": {
          "message": '',
          "description": 'the reasoning'
        },
        "recipient": 'morty@example.com',
        "user-variables": {
          "online_booking": true,
          "message_type": 'customer_booking_request',
          "environment": 'production'
        }
      }
    }

    post mail_gun_drops_path, params: payload, as: :json
  end

  def then_an_activity_is_created
    expect(@booking_request.activities).to_not be_empty
  end

  def and_an_email_is_sent_to_the_booking_manager
    expect(last_email.subject).to eq('Email Failure - Pension Wise Booking Request')
    expect(last_email.to).to eq(['rick@example.com'])
  end

  def and_a_push_notification_is_sent_to_online_booking_managers
    expect(Pusher).to have_received(:trigger).with(
      'drop_notifications',
      'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef',
      title: 'Email failure',
      fixed: true, delayOnHover: false,
      message: 'The email to morty@example.com failed to deliver',
      url: "/booking_requests/#{@booking_request.id}/appointments/new"
    )
  end

  def and_the_service_responds_ok
    expect(response).to be_successful
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end
end
