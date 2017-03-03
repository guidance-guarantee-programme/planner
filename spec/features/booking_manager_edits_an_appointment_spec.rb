# rubocop:disable Metrics/AbcSize
require 'rails_helper'

RSpec.feature 'Booking Manager edits an Appointment' do
  scenario 'Successfully editing an Appointment' do
    perform_enqueued_jobs do
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
    perform_enqueued_jobs do
      given_the_user_identifies_as_hackneys_booking_manager do
        and_there_is_an_appointment
        when_the_booking_manager_edits_the_appointment
        then_they_see_the_original_status
        when_they_modify_the_status
        then_the_status_is_updated
        and_the_customer_is_not_notified
      end
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

  def then_the_appointment_details_are_presented # rubocop:disable Metrics/MethodLength
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page.name.value).to eq(@appointment.name)
    expect(@page.email.value).to eq(@appointment.email)
    expect(@page.phone.value).to eq(@appointment.phone)
    expect(@page.memorable_word.value).to eq(@appointment.memorable_word)
    expect(@page.day_of_birth.value).to eq(@appointment.date_of_birth.day.to_s)
    expect(@page.month_of_birth.value).to eq(@appointment.date_of_birth.month.to_s)
    expect(@page.year_of_birth.value).to eq(@appointment.date_of_birth.year.to_s)
    expect(@page.defined_contribution_pot_confirmed_yes).to be_checked
    expect(@page.accessibility_requirements.value).to eq('1')

    # ensure Hackney is pre-selected
    expect(@page.location.value).to eq('ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')

    expect(@page.date.value).to eq('20 June 2016')
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

  def when_they_modify_the_appointment_details # rubocop:disable Metrics/MethodLength
    @page.name.set('Bob Jones')
    @page.email.set('bob@example.com')
    @page.phone.set('01189 888 888')
    @page.memorable_word.set('snarf')
    @page.day_of_birth.set('02')
    @page.month_of_birth.set('02')
    @page.year_of_birth.set('1945')
    @page.defined_contribution_pot_confirmed_dont_know.set true
    @page.accessibility_requirements.set(false)
    @page.date.set('21 June 2016')
    @page.time_hour.select('15')
    @page.time_minute.select('15')
    @page.guider.select('Bob Johnson')

    @page.submit.click
  end

  def then_the_appointment_is_updated
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page.name.value).to eq 'Bob Jones'
    expect(@page.date.value).to eq '21 June 2016'
    expect(@page.time_hour.value).to eq '15'
    expect(@page.time_minute.value).to eq '15'
    expect(@page.guider.find('option', text: 'Bob Johnson').selected?).to eq true
  end

  def and_the_customer_is_notified
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end

  def and_the_customer_is_not_notified
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  def then_they_see_the_original_status
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page.status.value).to eq 'pending'
  end

  def when_they_modify_the_status
    @page.status.select('Completed')
    @page.submit.click
  end

  def then_the_status_is_updated
    @page = Pages::EditAppointment.new
    expect(@page).to be_displayed

    expect(@page.status.value).to eq 'completed'
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
