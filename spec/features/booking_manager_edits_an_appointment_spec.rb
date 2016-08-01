# rubocop:disable Metrics/AbcSize
require 'rails_helper'

RSpec.feature 'Booking Manager edits an Appointment' do
  scenario 'Successfully editing an Appointment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment
      when_the_booking_manager_edits_the_appointment
      then_the_appointment_details_are_presented
      and_they_see_the_requested_slots
      when_they_modify_the_appointment_details
      then_the_appointment_is_updated
      and_the_customer_is_notified
    end
  end

  scenario 'Editing an Appointment causes validation failures' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment
      when_the_booking_manager_edits_the_appointment
      and_provides_invalid_information
      then_they_see_the_validation_messages
    end
  end

  scenario 'Update the status of an Appointment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_appointment
      when_the_booking_manager_edits_the_appointment
      then_they_see_the_original_status
      when_they_modify_the_status
      then_the_status_is_updated
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
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page.name.value).to eq(@appointment.name)
    expect(@page.email.value).to eq(@appointment.email)
    expect(@page.phone.value).to eq(@appointment.phone)

    # ensure Hackney is pre-selected
    expect(@page.location.value).to eq('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')

    expect(@page.date.value).to eq('2016-06-20')
    expect(@page.time_hour.value).to eq('14')
    expect(@page.time_minute.value).to eq('00')
  end

  def and_they_see_the_requested_slots
    @booking_request = @appointment.booking_request

    expect(@page.slot_one_date.text).to eq(@booking_request.primary_slot.formatted_date)
    expect(@page.slot_one_period.text).to eq(@booking_request.primary_slot.period)

    expect(@page.slot_two_date.text).to eq(@booking_request.secondary_slot.formatted_date)
    expect(@page.slot_two_period.text).to eq(@booking_request.secondary_slot.period)

    expect(@page.slot_three_date.text).to eq(@booking_request.tertiary_slot.formatted_date)
    expect(@page.slot_three_period.text).to eq(@booking_request.tertiary_slot.period)
  end

  def when_they_modify_the_appointment_details
    @page.name.set('Bob Jones')
    @page.date.set('2016-06-21')
    @page.time_hour.set('15')
    @page.time_minute.set('15')
    @page.guider.select('Bob Johnson')

    @page.submit.click
  end

  def then_the_appointment_is_updated
    @page = Pages::Appointments.new
    expect(@page).to be_displayed

    @page.appointments.first do |appointment|
      expect(appointment).to include('Bob Jones')
      expect(appointment).to include('Tues, 21 Jun')
      expect(appointment).to include('15:15')
      expect(appointment).to include('Bob Johnson')
    end
  end

  def and_the_customer_is_notified
    skip
  end

  def then_they_see_the_original_status
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page.status.value).to eq('pending')
  end

  def when_they_modify_the_status
    @page.status.select('Completed')
    @page.submit_status.click
  end

  def then_the_status_is_updated
    @page = Pages::Appointments.new
    expect(@page).to be_displayed

    @page.appointments.first do |appointment|
      expect(appointment).to include('Completed')
    end
  end

  def and_provides_invalid_information
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    @page.name.set('')
    @page.email.set('')
    @page.phone.set('')

    @page.submit.click
  end

  def then_they_see_the_validation_messages
    expect(@page).to have_error_summary
    expect(@page).to have_errors
  end
end
