class ScheduleRegenerationJob < ActiveJob::Base
  queue_as :default

  def perform
    ScheduleRegeneration.new.call
  end
end
