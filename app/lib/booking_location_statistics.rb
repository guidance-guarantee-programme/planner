class BookingLocationStatistics
  def initialize(statistics_serializer = StatisticsSerializer.new, statistics_web_hook = StatisticsWebHook.new)
    @statistics_serializer = statistics_serializer
    @statistics_web_hook   = statistics_web_hook
  end

  def call
    payload = statistics_serializer.json
    statistics_web_hook.call(payload)
  end

  private

  attr_reader :statistics_serializer
  attr_reader :statistics_web_hook
end
