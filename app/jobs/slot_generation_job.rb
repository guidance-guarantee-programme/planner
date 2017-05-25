class SlotGenerationJob < ActiveJob::Base
  queue_as :default

  def perform(schedule)
    schedule.generate_bookable_slots!
  end
end
