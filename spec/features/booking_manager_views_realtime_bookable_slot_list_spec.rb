require 'rails_helper'

RSpec.feature 'Booking manager views realtime bookable slot list' do
  scenario 'Viewing for a particular location' do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2019-05-17 13:00 UTC' do
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
    @slot = create(:bookable_slot)

    # this will not be displayed by default since it's before today
    @hidden = create(:bookable_slot, start_at: '2019-05-14 13:00', schedule: @slot.schedule)

    # this will be unavailable due to associated booking
    create_appointment_with_booking_slot(
      schedule: @slot.schedule,
      start_at: '2019-05-21 10:00',
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
      expect(slot.start_at).to have_text('9:00am, 17 May 2019')
      expect(slot.guider).to have_text('Ben Lovell')
      expect(slot.available).to have_text('Yes')
      expect(slot.created_at).to have_text('2:00pm, 17 May 2019')
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

  def create_appointment_with_booking_slot(schedule:, start_at:, guider_id:, status: :pending)
    slot    = create(:bookable_slot, schedule: schedule, start_at: start_at, guider_id: guider_id)
    booking = build(:hackney_booking_request, number_of_slots: 0)
    booking.slots.build(date: start_at.to_date, from: '1000', to: '1100', priority: 1)

    create(
      :appointment,
      booking_request: booking,
      guider_id: guider_id,
      proceeded_at: slot.start_at,
      status: status
    )
  end
end
