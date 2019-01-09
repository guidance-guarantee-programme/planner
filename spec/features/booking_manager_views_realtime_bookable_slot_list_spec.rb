require 'rails_helper'

RSpec.feature 'Booking manager views realtime bookable slot list' do
  scenario 'Viewing for a particular location' do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2018-11-26 13:00' do
        and_a_schedule_exists_with_realtime_slots
        when_they_view_the_list
        then_they_see_the_slots
        when_they_delete_a_slot
        then_the_slot_is_deleted
      end
    end
  end

  def and_a_schedule_exists_with_realtime_slots
    # this will be available
    @slot = create(:bookable_slot, :realtime)

    # this will be unavailable due to associated booking
    create_appointment_with_booking_slot(
      schedule: @slot.schedule,
      date: 5.days.from_now,
      guider_id: 1
    )
  end

  def when_they_view_the_list
    @page = Pages::RealtimeBookableSlotsList.new
    @page.load(location_id: @slot.schedule.location_id)
  end

  def then_they_see_the_slots # rubocop:disable AbcSize
    expect(@page).to be_displayed
    expect(@page).to have_slots(count: 2)

    @page.slots.first.tap do |slot|
      expect(slot.start_at).to have_text('9:00am, 26 November 2018')
      expect(slot.guider).to have_text('Ben Lovell')
      expect(slot.available).to have_text('Yes')
    end

    expect(@page.slots.last.available).to have_text('No')
  end

  def when_they_delete_a_slot
    @page.slots.first.delete.click
  end

  def then_the_slot_is_deleted
    expect(@page).to have_success
    expect(@page).to have_slots(count: 1)
  end

  def create_appointment_with_booking_slot(schedule:, date:, guider_id:, status: :pending)
    slot    = create(:bookable_slot, :realtime, schedule: schedule, date: date, guider_id: guider_id)
    booking = build(:hackney_booking_request, number_of_slots: 0)
    booking.slots.build(date: date, from: '0900', to: '1000', priority: 1)

    create(
      :appointment,
      booking_request: booking,
      guider_id: guider_id,
      proceeded_at: slot.start_at,
      status: status
    )
  end
end
