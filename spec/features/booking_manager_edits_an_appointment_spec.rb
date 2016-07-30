require 'rails_helper'

RSpec.feature 'Booking Manager edits an Appointment' do
  scenario 'Successfully editing an Appointment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment
      when_the_booking_manager_edits_the_appointment
      then_the_appointment_details_are_presented
      when_they_modify_the_appointment_details
      then_the_appointment_is_updated
      and_the_customer_is_notified
    end
  end

  def and_there_is_an_appointment
    @appointment = create(:appointment)
  end

  def when_the_booking_manager_edits_the_appointment
    @page = Pages::Appointments.new
    @page.load
    @page.appointments.first.edit.click
  end

  def then_the_appointment_details_are_presented
    skip
  end

  def when_they_modify_the_appointment_details
    skip
  end

  def then_the_appointment_is_updated
    skip
  end

  def and_the_customer_is_notified
    skip
  end
end
