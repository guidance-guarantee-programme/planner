class DefaultBookableSlots
  Instance = Struct.new(:date, :start, :end) do
    def label
      "#{date.to_date.strftime('%A').downcase}_#{period}"
    end

    def period
      BookableSlot::AM.period(start)
    end

    def realtime?
      false
    end

    def start_at
      @start_at ||= Time.zone.parse("#{date} #{start.dup.insert(2, ':')}")
    end
  end

  attr_reader :from
  attr_reader :to

  def initialize(from: Date.current, to: from.advance(weeks: 6), location_id:)
    @from = from
    @to   = to
    @location_id = location_id
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

  attr_reader :location_id

  def available_days
    (grace_period_end..to).reject { |day| day.on_weekend? || excluded?(day) }
  end

  def excluded?(date)
    Exclusions.new(location_id).include?(date)
  end

  def grace_period_end
    @grace_period_end ||= GracePeriod.new(location_id).start
  end
end
