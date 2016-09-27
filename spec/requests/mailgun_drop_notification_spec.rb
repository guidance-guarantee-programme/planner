require 'rails_helper'

RSpec.describe 'POST /mail_gun/drops' do
  scenario 'inbound hooks create activity entries' do
    with_a_configured_token('deadbeef') do
      given_a_hackney_booking_request
      when_mail_gun_posts_a_drop_notification
      then_an_activity_is_created
      and_the_service_responds_ok
    end
  end

  def with_a_configured_token(token)
    existing = ENV['MAILGUN_API_TOKEN']

    ENV['MAILGUN_API_TOKEN'] = token
    yield
  ensure
    ENV['MAILGUN_API_TOKEN'] = existing
  end

  def given_a_hackney_booking_request
    @booking_request = create(:hackney_booking_request)
  end

  def when_mail_gun_posts_a_drop_notification
    post mail_gun_drops_path, params: {
      'event' => 'dropped',
      'recipient' => 'morty@example.com',
      'description' => 'the reasoning',
      'environment' => 'production',
      'online_booking' => 'True',
      'timestamp' => '1474638633',
      'token' => 'secret',
      'signature' => 'abf02bef01e803bea52213cb092a31dc2174f63bcc2382ba25732f4c84e084c1'
    }
  end

  def then_an_activity_is_created
    expect(@booking_request.activities).to_not be_empty
  end

  def and_the_service_responds_ok
    expect(response).to be_success
  end
end
