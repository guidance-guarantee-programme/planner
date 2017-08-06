require 'rails_helper'

RSpec.feature 'Scheduled slot regeneration' do
  scenario 'Regenerating slots for a given schedule' do
    travel_to '2017-07-18 13:00' do
      given_a_schedule_requiring_regeneration_exists
      when_the_slot_regeneration_job_is_performed
      then_the_necessary_slots_are_generated
      and_the_slots_prior_to_cutoff_are_not_modified
    end
  end

  def given_a_schedule_requiring_regeneration_exists
    @schedule = create(:schedule, :blank, monday_am: true) do |schedule|
      # this should be left as-is after regeneration
      @prior_to_cutoff = create(:bookable_slot, :am, schedule: schedule, date: 1.day.ago)

      # this is the last slot, landing on the cutoff
      @lands_on_cutoff = create(:bookable_slot, :am, schedule: schedule, date: 8.weeks.from_now)
    end
  end

  def when_the_slot_regeneration_job_is_performed
    ScheduleRegenerationJob.new.perform
  end

  def then_the_necessary_slots_are_generated
    expect(@schedule.bookable_slots.last).to have_attributes(
      date: Date.parse('2018-01-08'),
      start: BookableSlot::AM.start,
      end: BookableSlot::AM.end
    )
  end

  def and_the_slots_prior_to_cutoff_are_not_modified
    expect(@schedule.bookable_slots).to include(@prior_to_cutoff)
  end
end
