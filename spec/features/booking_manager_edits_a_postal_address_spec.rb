require 'rails_helper'

RSpec.feature 'Booking Manager edits a postal address' do
  scenario 'Successfully editing a postal address before fulfilment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_unfulfilled_postal_booking_request
      when_the_booking_manager_views_the_booking_request
      and_then_edits_the_postal_address
      then_the_postal_address_details_are_presented
      when_the_booking_manager_submits_a_valid_address
      then_the_postal_address_is_updated
    end
  end

  scenario 'Successfully editing a postal address after fulfilment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_a_fulfilled_postal_booking_request
      when_the_booking_manager_edits_the_appointment
      and_then_edits_the_postal_address
      then_the_postal_address_details_are_presented
      when_the_booking_manager_submits_a_valid_address
      then_the_postal_address_is_updated
    end
  end

  scenario 'Editing a postal address before fulfilment cause validation errors' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_unfulfilled_postal_booking_request
      when_the_booking_manager_views_the_booking_request
      and_then_edits_the_postal_address
      then_the_postal_address_details_are_presented
      when_the_booking_manager_submits_an_invalid_address
      then_the_postal_address_details_are_represented_with_an_error
    end
  end

  scenario 'Editing a postal address after fulfilment cause validation errors' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_a_fulfilled_postal_booking_request
      when_the_booking_manager_edits_the_appointment
      and_then_edits_the_postal_address
      then_the_postal_address_details_are_presented
      when_the_booking_manager_submits_an_invalid_address
      then_the_postal_address_details_are_represented_with_an_error
    end
  end

  scenario 'Cancelling an edit of a postal address before fulfilment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_an_unfulfilled_postal_booking_request
      when_the_booking_manager_views_the_booking_request
      and_then_edits_the_postal_address
      then_the_postal_address_details_are_presented
      when_the_booking_manager_cancels_the_edit
      then_the_postal_address_is_unchanged
    end
  end

  scenario 'Cancelling an edit of a postal address after fulfilment' do
    given_the_user_identifies_as_hackneys_booking_manager do
      and_there_is_a_fulfilled_postal_booking_request
      when_the_booking_manager_edits_the_appointment
      and_then_edits_the_postal_address
      then_the_postal_address_details_are_presented
      when_the_booking_manager_cancels_the_edit
      then_the_postal_address_is_unchanged
    end
  end

  def and_there_is_an_unfulfilled_postal_booking_request
    @agent = create(:agent)
    @booking_request = create(:postal_booking_request, name: 'Mortimer Smith', email: '', agent: @agent)
  end

  def and_there_is_a_fulfilled_postal_booking_request
    @agent = create(:agent)
    @booking_request = create(:postal_booking_request, agent: @agent)
    @appointment = create(:appointment, name: 'Mortimer Smith', email: '', booking_request: @booking_request)
  end

  def when_the_booking_manager_views_the_booking_request
    @page = Pages::BookingRequests.new
    @page.load
    @page.booking_requests.first.fulfil.click
  end

  def when_the_booking_manager_edits_the_appointment
    @page = Pages::Appointments.new
    @page.load
    @page.appointments.first.edit.click
  end

  def and_then_edits_the_postal_address
    @page = edit_or_new_appointment_page
    @page.edit_postal_address.click
  end

  def then_the_postal_address_details_are_presented # rubocop:disable Metrics/AbcSize
    @page = Pages::EditPostalAddress.new

    expect(@page.address_line_one).to have_value('22 Dalston Lane')
    expect(@page.town).to have_value('Hackney')
    expect(@page.county).to have_value('London')
    expect(@page.postcode).to have_value('E8 3AZ')
  end

  def when_the_booking_manager_submits_a_valid_address
    @page = Pages::EditPostalAddress.new

    @page.address_line_one.set('24 Dalston Lane')
    @page.submit.click
  end

  def then_the_postal_address_is_updated
    @page = edit_or_new_appointment_page
    expect(@page.postal_address).to have_text('24 Dalston Lane')
  end

  def when_the_booking_manager_submits_an_invalid_address
    @page = Pages::EditPostalAddress.new

    @page.address_line_one.set('')
    @page.town.set('')
    @page.postcode.set('')
    @page.submit.click
  end

  def then_the_postal_address_details_are_represented_with_an_error # rubocop:disable Metrics/AbcSize
    @page = Pages::EditPostalAddress.new

    expect(@page.errors).to have_text("There's a problem")
    expect(@page.errors).to have_text("Address line one can't be blank")
    expect(@page.errors).to have_text("Town can't be blank")
    expect(@page.errors).to have_text("Postcode can't be blank")

    expect(@page.address_line_one).to have_value('')
    expect(@page.town).to have_value('')
    expect(@page.postcode).to have_value('')
  end

  def when_the_booking_manager_cancels_the_edit
    @page = Pages::EditPostalAddress.new
    @page.cancel.click
  end

  def then_the_postal_address_is_unchanged
    @page = edit_or_new_appointment_page
    expect(@page.postal_address).to have_text('22 Dalston Lane')
  end

  def edit_or_new_appointment_page
    if defined?(@appointment)
      Pages::EditAppointment.new
    else
      Pages::FulfilBookingRequest.new
    end
  end
end
