class SlotGenerationJob < ActiveJob::Base
  queue_as :default

  def perform(schedule)
  end
end
