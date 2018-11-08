class DefaultBookableSlots
  Instance = Struct.new(:date, :start, :end) do
    def label
      "#{date.to_date.strftime('%A').downcase}_#{period}"
    end

    def period
      BookableSlot::AM.period(start)
    end
  end

  attr_reader :from
  attr_reader :to

  def initialize(from: Date.current, to: from.advance(weeks: 6))
    @from = from
    @to   = to
  end

  def call
    available_days.map do |date|
      [
        Instance.new(date.iso8601, *BookableSlot::AM.pair),
        Instance.new(date.iso8601, *BookableSlot::PM.pair)
      ]
    end.flatten
  end

  private

  def available_days
    (grace_period_end..to).reject { |day| day.on_weekend? || excluded?(day) }
  end

  def excluded?(date)
    EXCLUSIONS.include?(date)
  end

  def grace_period_end
    GracePeriod.start
  end
end
