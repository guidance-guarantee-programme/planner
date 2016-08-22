require 'rails_helper'

RSpec.feature 'Booking Manager views Booking / Appointment Activities' do
  scenario 'Viewing activities from an Appointment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment_for_their_location
      and_the_appointment_was_updated_multiple_times
      when_they_view_the_appointment
      then_they_see_the_update_displayed_as_an_activity
    end
  end

  def and_there_is_an_appointment_for_their_location
    @appointment = create(:appointment)
  end

  def and_the_appointment_was_updated_multiple_times
    @appointment.name = 'Mortimer Birdperson'
    @appointment.save!

    @appointment.email = 'mortimer@example.com'
    @appointment.save!
  end

  def when_they_view_the_appointment
    @page = Pages::EditAppointment.new
    @page.load(id: @appointment.id)
  end

  def then_they_see_the_update_displayed_as_an_activity
    @page.activity_feed.tap do |feed|
      expect(feed).to have_activities(count: 1)
    end
  end
end
