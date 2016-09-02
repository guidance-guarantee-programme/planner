require 'rails_helper'

RSpec.feature 'Booking Manager views Booking / Appointment Activities', js: true do
  scenario 'Viewing activities from an Appointment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      with_configured_polling(milliseconds: 2000) do
        and_there_is_an_appointment_for_their_location
        and_the_appointment_was_updated_multiple_times
        when_they_view_the_appointment
        then_they_see_the_last_activity
        when_they_request_further_activities
        then_they_see_all_the_activities
        when_somebody_else_adds_an_activity
        then_it_appears_dynamically
      end
    end
  end

  def and_there_is_an_appointment_for_their_location
    @appointment = create(:appointment)
  end

  def and_the_appointment_was_updated_multiple_times
    @appointment.update(name: 'Mortimer Birdperson')
    @appointment.update(email: 'mortimer@example.com')
  end

  def when_they_view_the_appointment
    @page = Pages::EditAppointment.new
    @page.load(id: @appointment.id)
  end

  def then_they_see_the_last_activity
    @page.activity_feed.tap do |feed|
      expect(feed).to have_activities(count: 1)
      expect(feed.activities.first).to have_text('email')
    end
  end

  def when_they_request_further_activities
    @page.activity_feed.further_activities.click
  end

  def then_they_see_all_the_activities
    @page.activity_feed.tap do |feed|
      feed.wait_for_hidden_activities

      expect(feed).to have_activities(count: 2)
      expect(feed.activities.last).to have_text('name')
    end
  end

  def when_somebody_else_adds_an_activity
    @activity = create(:activity, booking_request: @appointment.booking_request)
  end

  def then_it_appears_dynamically
    expect(@page).to have_text(@activity.owner_name)
    expect(@page).to have_text(@activity.message)
  end

  def with_configured_polling(milliseconds:)
    previous = ENV[Activity::POLLING_KEY]
    ENV[Activity::POLLING_KEY] = milliseconds.to_s

    yield
  ensure
    ENV[Activity::POLLING_KEY] = previous
  end
end
