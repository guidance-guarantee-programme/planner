require 'rails_helper'

RSpec.feature 'Booking manager copies realtime slots for a guider', js: true do
  scenario 'With validation issues' do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2019-02-26 09:00' do
        and_a_schedule_with_slots_exists
        when_they_view_realtime_availability
        and_click_on_a_guider
        and_submit_a_blank_copy_modal
        then_they_see_errors
      end
    end
  end

  scenario 'Without validation issues' do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2019-02-26 09:00' do
        and_a_schedule_with_slots_exists
        when_they_view_realtime_availability
        and_click_on_a_guider
        and_complete_the_form
        then_they_see_the_previewed_slots
        when_they_confirm_the_previewed_slots
        then_the_modal_is_closed
        and_the_correct_slots_are_copied
      end
    end
  end

  def and_complete_the_form
    @page.copy_modal.check('9:00am')
    @page.copy_modal.check('Monday')
    @page.copy_modal.check('Friday')

    # enter date range manually and close date picker
    @page.copy_modal.date_range.set("04/03/2019 - 15/03/2019\n")
  end

  def then_they_see_the_previewed_slots
    expect(@page.copy_modal).to have_good_slots
    expect(@page.copy_modal).to have_bad_slots(count: 1)
  end

  def when_they_confirm_the_previewed_slots
    accept_alert do
      @page.copy_modal.save.click
    end
  end

  def then_the_modal_is_closed
    @page.wait_until_copy_modal_invisible
  end

  def and_the_correct_slots_are_copied
    @actual   = BookableSlot.where(guider_id: @slot.guider_id).map(&:start_at)
    @expected = [
      '2019-02-26 09:00',
      '2019-03-04 09:15',
      '2019-03-08 09:00',
      '2019-03-11 09:00',
      '2019-03-15 09:00'
    ].map(&:to_time)

    expect(@actual).to eq(@expected)
  end

  def and_a_schedule_with_slots_exists
    @slot = create(:bookable_slot, :realtime)

    # this won't be overwritten by the copied slot as they overlap
    create(:bookable_slot, :realtime, schedule: @slot.schedule, date: '2019-03-04', start: '0915')
  end

  def when_they_view_realtime_availability
    @page = Pages::RealtimeAvailability.new
    @page.load(location_id: @slot.schedule.location_id)
  end

  def and_click_on_a_guider
    @page.guiders.first.click
  end

  def and_submit_a_blank_copy_modal
    @page.wait_until_copy_modal_visible
    @page.copy_modal.save.click
  end

  def then_they_see_errors
    expect(@page.copy_modal).to have_errors
  end
end
