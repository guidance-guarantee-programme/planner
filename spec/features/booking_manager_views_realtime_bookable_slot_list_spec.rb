require 'rails_helper'

RSpec.feature 'Booking manager views realtime bookable slot list' do
  scenario 'Viewing for a particular location' do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2018-11-26 13:00' do
        and_a_schedule_exists_with_realtime_slots
        when_they_view_the_list
        then_they_see_the_slots
      end
    end
  end

  def and_a_schedule_exists_with_realtime_slots
    @slot = create(:bookable_slot, :realtime)
  end

  def when_they_view_the_list
    @page = Pages::RealtimeBookableSlotsList.new
    @page.load(location_id: @slot.schedule.location_id)
  end

  def then_they_see_the_slots # rubocop:disable AbcSize
    expect(@page).to be_displayed
    expect(@page).to have_slots(count: 1)

    @page.slots.first.tap do |slot|
      expect(slot.start_at).to have_text('9:00am, 26 November 2018')
      expect(slot.guider).to have_text('Ben Lovell')
      expect(slot.available).to have_text('Yes')
    end
  end
end
