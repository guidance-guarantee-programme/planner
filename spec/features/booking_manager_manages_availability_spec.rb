require 'rails_helper'

RSpec.feature 'Booking manager manages availability' do
  scenario 'Modifying a booking location’s availability', js: true do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2017-06-12 13:00' do
        and_a_schedule_exists
        when_they_view_their_schedules
        and_choose_to_edit_the_availability
        then_they_are_shown_the_existing_availability
        when_they_remove_a_slot
        and_they_add_another
        then_the_availability_is_affected
      end
    end
  end

  def and_a_schedule_exists
    @schedule = create(:schedule, :blank, monday_am: true, &:generate_bookable_slots!)
  end

  def when_they_view_their_schedules
    @page = Pages::Schedules.new.tap(&:load)
    expect(@page).to be_loaded
  end

  def and_choose_to_edit_the_availability
    @page.schedules.first.availability.click
  end

  def then_they_are_shown_the_existing_availability
    @page = Pages::Availability.new
    expect(@page).to be_displayed

    # two Monday AM slots will be present
    @page.calendar.wait_for_events
    expect(@page.calendar).to have_events(count: 2)
  end

  def when_they_remove_a_slot
    # click on today's availability
    @page.calendar.events.last.click

    @page.wait_until_availability_modal_visible
    @page.availability_modal.tap do |modal|
      expect(modal.title.text).to eq('Availability for 26 June 2017')

      modal.am.click
    end
  end

  def and_they_add_another
    @page.availability_modal.pm.click
    @page.availability_modal.save.click
  end

  def then_the_availability_is_affected
    @page.wait_until_availability_modal_invisible

    @page.wait_for_calendar_events
    @page.calendar.events.tap do |events|
      expect(events.first).to have_text('AM')
      expect(events.last).to  have_text('PM')
    end
  end
end
