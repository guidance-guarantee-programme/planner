class StatisticHooksJob < ActiveJob::Base
  queue_as :default

  def perform
    BookingLocationStatistics.new.call
  end
end
