require 'rails_helper'

RSpec.feature 'Booking manager manages realtime availability' do
  scenario 'Attempting to add a slot that would overlap in another schedule', driver: :poltergeist do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2026-02-22 09:00' do
        and_a_schedule_exists
        and_a_schedule_for_dalston_exists_with_slots
        when_they_view_their_schedules
        and_choose_to_edit_the_realtime_availability
        then_they_are_shown_the_existing_availability
        when_they_attempt_to_add_a_slot_for_hackney
        then_they_are_told_an_overlapping_slot_exists_in_dalston
      end
    end
  end

  scenario 'Adding realtime slots to an existing schedule', driver: :poltergeist do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2018-10-26 13:00' do
        and_a_schedule_exists
        when_they_view_their_schedules
        and_choose_to_edit_the_realtime_availability
        then_they_are_shown_the_existing_availability
        when_they_add_a_slot_for_a_specific_guider
        then_the_slot_is_created
        when_they_remove_a_slot_for_a_specific_guider
        then_the_slot_is_removed
      end
    end
  end

  def and_a_schedule_exists
    @schedule = create(:schedule)
  end

  def and_a_schedule_for_dalston_exists_with_slots
    @dalston_schedule = create(:schedule, :dalston)
    @dalston_slot = create(
      :bookable_slot,
      start_at: Time.zone.parse('2026-02-23 09:00'),
      end_at: Time.zone.parse('2026-02-23 10:00'),
      schedule: @dalston_schedule
    )
  end

  def when_they_attempt_to_add_a_slot_for_hackney
    @page.wait_for_calendar_events
    @page.click_slot('09:00', 'B Lovell')
  end

  def then_they_are_told_an_overlapping_slot_exists_in_dalston
    @page.wait_until_alert_visible
    expect(@page.alert).to have_text('Overlaps with a slot in Dalston')
  end

  def when_they_view_their_schedules
    @page = Pages::Schedules.new
    @page.load
  end

  def and_choose_to_edit_the_realtime_availability
    expect(@page).to have_schedules
    # hidden from non-administrator roles
    expect(@page.schedules.first).to have_no_clear_future_slots
    # Hackney
    @page.schedules.first.realtime_availability.click
  end

  def then_they_are_shown_the_existing_availability
    @page = Pages::RealtimeAvailability.new
    expect(@page).to be_loaded
  end

  def when_they_add_a_slot_for_a_specific_guider
    @page.wait_for_calendar_events
    @page.click_slot('08:00', 'B Lovell')
  end

  def then_the_slot_is_created
    @page.wait_for_calendar_events
    expect(@page).to have_slots(count: 1)
  end

  def when_they_remove_a_slot_for_a_specific_guider
    @page.click_slot('08:00', 'B Lovell')
    @page.accept_confirmation
  end

  def then_the_slot_is_removed
    @page.wait_for_calendar_events
    expect(@page).to_not have_slots
  end
end
