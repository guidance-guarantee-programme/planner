require 'rails_helper'

RSpec.feature 'Appointment counts displayed on schedules', js: true do
  scenario 'Viewing the right appointment counts' do
    given_the_user_identifies_as_hackneys_booking_manager do
      travel_to '2017-07-12 13:00' do
        and_i_have_a_schedule
        and_i_am_examining_bookable_slots_for_a_particular_date

        and_there_is_one_appointment_first_thing_in_the_morning
        and_there_is_one_appointment_mid_morning
        and_there_is_one_appointment_late_morning

        and_there_is_an_appointment_at_1pm
        and_there_is_one_appointment_mid_afternoon
        and_there_is_one_appointment_last_thing_in_the_day

        when_i_look_at_the_schedule
        then_i_see_there_are_three_appointments_in_the_morning
        and_i_see_there_are_three_appointments_in_the_afternoon
      end
    end
  end
end

def and_i_have_a_schedule
  @schedule = create(:schedule)
end

def and_i_am_examining_bookable_slots_for_a_particular_date
  @date = Date.current.next_week(:wednesday).to_s
  @am_slot = create(:bookable_slot, :am, date: @date, schedule: @schedule)
  @pm_slot = create(:bookable_slot, :pm, date: @date, schedule: @schedule)
end

def and_there_is_one_appointment_first_thing_in_the_morning
  create(:appointment, proceeded_at: Time.zone.parse("#{@date} 09:00"))
end

def and_there_is_one_appointment_mid_morning
  create(:appointment, proceeded_at: Time.zone.parse("#{@date} 11:00"))
end

def and_there_is_one_appointment_late_morning
  create(:appointment, proceeded_at: Time.zone.parse("#{@date} 12:30"))
end

def and_there_is_an_appointment_at_1pm
  create(:appointment, proceeded_at: Time.zone.parse("#{@date} 13:00"), guider_id: 2)
end

def and_there_is_one_appointment_mid_afternoon
  create(:appointment, proceeded_at: Time.zone.parse("#{@date} 15:00"))
end

def and_there_is_one_appointment_last_thing_in_the_day
  create(:appointment, proceeded_at: Time.zone.parse("#{@date} 17:00"))
end

def when_i_look_at_the_schedule
  @page = Pages::BookableSlots.new
  @page.load(location_id: 'ac7112c3-e3cf-45cd-a8ff-9ba827b8e7ef')
end

def then_i_see_there_are_three_appointments_in_the_morning
  expect(@page.slot(@am_slot)).to have_content(3)
end

def and_i_see_there_are_three_appointments_in_the_afternoon
  expect(@page.slot(@pm_slot)).to have_content(3)
end
